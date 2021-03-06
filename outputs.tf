output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

output "kubectl_config" {
  description = "kubectl config as generated by the module."
  value       = module.eks.kubeconfig
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = module.eks.config_map_aws_auth
}

output "region" {
  description = "AWS region"
  value       = var.region
}

#
output "lb" {
  description = "DNS name of the Load Balancer"
  value = kubernetes_service.vlad_service.status.0.load_balancer.0.ingress.0.hostname
}
output "es_domain" {
  description = "DNS name of the Elasticsearch service"
  value = aws_elasticsearch_domain.es.domain_name
}

output "es_endpoint" {
  description = "DNS name of the Elasticsearch endpoint"
  value = aws_elasticsearch_domain.es.endpoint
}

output "es_kibana" {
  description = "DNS name of the Elasticsearch Kibana service"
  value = aws_elasticsearch_domain.es.kibana_endpoint
}

