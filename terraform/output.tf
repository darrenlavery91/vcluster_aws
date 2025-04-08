output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_endpoint" {
  description = "EKS endpoint URL"
  value       = module.eks.cluster_endpoint
}

output "eks_oidc_provider" {
  description = "OIDC provider for IAM roles"
  value       = module.eks.oidc_provider_arn
}
