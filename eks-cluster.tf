module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  cluster_name    = var.eks_cluster_name
  cluster_version = "1.18"
  subnets         = module.vpc.private_subnets
  version = "12.2.0"
  cluster_create_timeout = "1h"
  cluster_endpoint_private_access = true

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      asg_desired_capacity          = 1
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
  ]

  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  map_roles                            = var.map_roles
  map_users                            = var.map_users
  map_accounts                         = var.map_accounts
}

resource "kubernetes_deployment" "vlad_deployment" {
  metadata {
    name = "vlad-example"
    labels = {
      test = "MyApp"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        test = "MyApp"
      }
    }

    template {
      metadata {
        labels = {
          test = "MyApp"
        }
      }

      spec {
        container {
          image = "httpd:latest"
          name  = "vlad-example"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "vlad_service" {
  metadata {
    name = "vlad-example"
  }
  spec {
    selector = {
      test = "MyApp"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}



locals {
  name = "fluentd"

  labels = {
    k8s-app = "fluentd-logging"
    version = "v1"
  }

  env_variables = {
    "HOST" : aws_elasticsearch_domain.es.endpoint,
    "PORT" : "9200",
    "SCHEME" : "http",
    "USER" : null,
    "PASSWORD" : null
  }
}


resource "kubernetes_daemonset" "fluentd" {
  metadata {
    name      = local.name
    namespace = "kube-system"

    labels = local.labels
  }


  spec {
    selector {
      match_labels = {
        k8s-app = local.labels.k8s-app
      }
    }

    template {
      metadata {
        labels = local.labels
      }

      spec {
        volume {
          name = "varlog"

          host_path {
            path = "/var/log"
          }
        }

        volume {
          name = "varlibdockercontainers"

          host_path {
            path = "/var/lib/docker/containers"
          }
        }

        container {
          name  = local.name
          image = "fluent/fluentd-kubernetes-daemonset:v1-debian-elasticsearch"

          dynamic "env" {
            for_each = local.env_variables
            content {
              name  = "FLUENT_ELASTICSEARCH_${env.key}"
              value = env.value
            }
          }

          resources {
            limits = {
              memory = "200Mi"
            }

            requests = {
              cpu    = "100m"
              memory = "200Mi"
            }
          }

          volume_mount {
            name       = "varlog"
            mount_path = "/var/log"
          }

          volume_mount {
            name       = "varlibdockercontainers"
            read_only  = true
            mount_path = "/var/lib/docker/containers"
          }
        }

        termination_grace_period_seconds = 30
        service_account_name             = local.name
      }
    }
  }
}

