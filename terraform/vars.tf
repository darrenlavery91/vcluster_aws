variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "af-south-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "vcluster-demo"
}

variable "cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.27"
}

variable "desired_capacity" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Max number of worker nodes"
  type        = number
  default     = 3
}

variable "min_capacity" {
  description = "Min number of worker nodes"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "EC2 instance type for the node group"
  type        = string
  default     = "t3.medium"
}
