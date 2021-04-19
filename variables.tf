#AWS
variable "region" {
  default     = "eu-central-1"
  description = "AWS region"
}


#ElasticSearch vars
variable "es_domain" {
  default = "vlad-test"
  description = "ElasticSearch domain name"
}

variable "es_vers" {
  default = "7.9"
  description = "Elasticsearch version"
}

variable "es_instance" {
  default = "t3.small.elasticsearch"
  description = "Elasticsearch instance"
}

variable "sg_name" {
  default = "elasticsearch sg"
  description = "Elasticsearch security group"
}

variable "es_user" {
  default = "master"
  description = "Elasticsearch username"
}
variable "es_pass" {
  default = "T0dot$ebeStPassW0rD"
  description = "Elasticsearch user password"
}

#EKS
variable "eks_cluster_name" {
  default = "vlad_test_eks"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "777777777777",
    "888888888888",
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::66666666666:user/user1"
      username = "user1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::66666666666:user/user2"
      username = "user2"
      groups   = ["system:masters"]
    },
  ]
}