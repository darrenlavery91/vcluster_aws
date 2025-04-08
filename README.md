### Getting Started: EKS Setup for vCluster

If you don’t already have an EKS cluster, start by creating one. You can use Terraform for automation, but here’s a quick manual setup using `eksctl`.

Check out: https://medium.com/p/5e7057744bcc/edit

---

### Prerequisites

Make sure the following tools are installed:

- [vCluster](https://www.vcluster.com/) by Loft
- [AWS `eksctl`](https://eksctl.io/)
- [Helm](https://helm.sh/) version 3 or higher

---

### Step 1: Create the EKS Cluster

Create a file called `cluster.yaml` with the following content (you can adjust values as needed):

```bash
CLUSTER_NAME=vcluster-demo
REGION=eu-central-1
INSTANCE_TYPE=t3.medium

cat <<EOF > cluster.yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: ${CLUSTER_NAME}
  region: ${REGION}
nodeGroups:
  - name: ng-1
    instanceType: ${INSTANCE_TYPE}
    desiredCapacity: 2
    iam:
      withAddonPolicies:
        ebs: true
    volumeSize: 80

addons:
  - name: aws-ebs-csi-driver
    wellKnownPolicies:
      ebsCSIController: true
EOF
```

> ⚠️ **Important:** Double-check your **region** and **instance type**. These settings can impact cost significantly.

Now create the cluster:

```bash
eksctl create cluster -f cluster.yaml
```

---

### Step 2: Verify the Cluster

Once provisioning completes, confirm the EBS CSI driver is running:

```bash
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver
```

---

### Step 3: Set a Default StorageClass

`vCluster` requires a default `StorageClass` for persistent volume provisioning. Apply the following configuration for `gp3`:

```yaml
cat <<EOF | kubectl apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gp3
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
  encrypted: "true"
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
EOF
```

Then remove the default status from the `gp2` `StorageClass`:

```bash
kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
```
