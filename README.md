# Secure Automated Web Architecture

## Description

This project provisions a secure, automated web server on AWS entirely through Infrastructure as Code. A custom VPC, subnet, and firewall rules are built from scratch with Terraform, a GitHub Actions pipeline scans every change for security misconfigurations before it can reach production, and the web server bootstraps itself on launch with no manual server configuration required.

## Technologies Used

- **AWS** — VPC, EC2, IAM, KMS, CloudWatch, VPC Flow Logs
- **Terraform** — infrastructure provisioning and state management
- **GitHub Actions** — CI/CD pipeline and automated deployment gate
- **tfsec** — static application security testing (SAST) for Terraform

## Architecture

The network is built as a single public VPC (`10.0.0.0/16`) containing one public subnet (`10.0.1.0/24`). An Internet Gateway and a route table with a `0.0.0.0/0` route give the subnet outbound and inbound internet reachability, which is required since this subnet hosts a public-facing web server.

Access into the environment is locked down at the security group level: **port 80 (HTTP)** is open to the internet so the web server can serve traffic, while **port 22 (SSH)** is restricted to a single authorized IP address (`/32`), preventing unauthorized remote access to the instance. All outbound traffic is permitted so the instance can retrieve OS packages during boot.

The EC2 instance itself is hardened beyond the network layer:
- **IMDSv2 is enforced** (`http_tokens = "required"`), closing a common SSRF-to-credential-theft attack path against the instance metadata service.
- **The root EBS volume is encrypted** at rest.
- **VPC Flow Logs** capture all network traffic in the VPC to a dedicated, KMS-encrypted CloudWatch Log Group, giving full network visibility for future incident investigation.

Every change to this repository's `main` branch is automatically scanned by a `tfsec` quality gate in GitHub Actions before it's considered safe to deploy — the pipeline breaks the build on any unresolved critical or high-severity finding, and any exception to a security rule (such as the intentional public HTTP ingress) is explicitly documented in-line in the Terraform code rather than silently suppressed.

## Next Steps

Future iterations of this project could add HTTPS termination via an Application Load Balancer and ACM certificate, move the web server into a private subnet behind the load balancer, and introduce Auto Scaling for high availability.
