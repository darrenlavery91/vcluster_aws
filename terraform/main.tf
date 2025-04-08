provider "aws" {
  region = var.aws_region
}

data "local_file" "storage_class_yaml" {
  filename = "${path.module}/../StorageClass.yaml"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 19.21"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = var.private_subnets
  vpc_id          = var.vpc_id

  node_groups = {
    ng-1 = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 2
      instance_types   = ["t3.medium"]
    }
  }
}

module "ebs_csi_driver" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "ebs-csi-driver-role"
  attach_ebs_csi_policy = true
  oidc_providers = [{
    provider_arn               = module.eks.oidc_provider_arn
    namespace_service_accounts = ["kube-system:ebs-csi-controller"]
  }]
}

resource "aws_eks_addon" "aws_ebs_csi_driver" {
  cluster_name = module.eks.cluster_name
  addon_name   = "aws-ebs-csi-driver"
}

resource "kubectl_manifest" "gp3_storage_class" {
  yaml_body = data.local_file.storage_class_yaml.content
}

resource "null_resource" "remove_gp2_default" {
  provisioner "local-exec" {
    command = "kubectl patch storageclass gp2 -p '{\"metadata\": {\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"false\"}}}'"
  }
  depends_on = [kubectl_manifest.gp3_storage_class]
}
