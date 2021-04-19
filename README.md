# terraform-test-task
Task:
Run Kubernetes cluster on AWS/GCP/Bare metal with EFK stack
Conditions:
- You have to use Terraform to describe all infrastructure;
- You have to create a Deployment with Apache server and expose it through a Load
Balancer;
- All k8s logs should be captured and delivered to an Elasticsearch cluster;
- Kubernetes and Elasticsearch clusters should be separated (use AWS Elasticsearch if
possible);
Optional (advanced):
- Deploy a Wordpress site instead of default Apache service into k8s, expose it
through a Load Balancer and catch logs via EFK stack;
The entire process should be as automated as possible and all services should be raised by one command only.

My tf config actually corresponds not to all conditions. It sets up the EKS cluster with Apache server and exposes it through the LoadBalancer.Also it sets up Elasticsearch cluster using AWS Elasticsearch service(elasticsearch domain resource in terraform). However, the main obstacle for me was to connect EKS cluster with  ES domain. I've tried to set up a fluentd on EKS cluster(using daemon set) but it doesn't work properly. Maybe, problem is in k8 manifest, but I haven't got much time to fix this issue now.
