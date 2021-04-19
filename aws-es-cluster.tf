# Data for ec

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Elasticsearch
resource "aws_elasticsearch_domain" "es" {
  domain_name = var.es_domain
  elasticsearch_version = var.es_vers

  cluster_config {
    instance_type = var.es_instance
    instance_count = 1
  }

  vpc_options {
    subnet_ids = [module.vpc.public_subnets[0]]

    security_group_ids = [aws_security_group.es-sg.id]
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.es_domain}/*"
        }
    ]
}
CONFIG

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  node_to_node_encryption {
    enabled = true
  }

  encrypt_at_rest {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 20
  }

  advanced_security_options {
    enabled = true
    internal_user_database_enabled = true


    master_user_options {
      master_user_name = var.es_user
      master_user_password = var.es_pass
    }



  }
    tags = {
      Terraform = "true"
      Environment = "vlad-test"
    }

  }

