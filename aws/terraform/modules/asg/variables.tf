variable "project_name" {
  description = "Project name for tagging"
  type        = string
}

variable "instance_ami" {
  description = "AMI ID to use for application instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for application instances"
  type        = string
}

variable "web_sg_id" {
  description = "Security group id for web instances"
  type        = string
}

variable "user_data" {
  description = "User data script to configure the instance"
  type        = string
  default     = "#!/bin/bash\n# update packages\nif command -v apt-get >/dev/null 2>&1; then apt-get update -y || true; else yum update -y || true; fi\n# Try to install and start SSM agent so we can debug instances via SSM (best-effort)\nif command -v yum >/dev/null 2>&1; then\n  yum install -y amazon-ssm-agent || true\n  systemctl enable amazon-ssm-agent || true\n  systemctl start amazon-ssm-agent || true\nelif command -v apt-get >/dev/null 2>&1; then\n  # some distros provide amazon-ssm-agent via package, others require the deb from S3;\n  apt-get install -y amazon-ssm-agent || true\n  systemctl enable amazon-ssm-agent || true\n  systemctl start amazon-ssm-agent || true\nfi\n# Install and start nginx (best-effort)\nif command -v apt-get >/dev/null 2>&1; then\n  apt-get install -y nginx || true\n  systemctl enable nginx || true\n  systemctl start nginx || true\nelse\n  yum install -y nginx || true\n  systemctl enable nginx || true\n  systemctl start nginx || true\nfi\n# Ensure web root exists\nmkdir -p /var/www/html || true\n# Generate an index page that shows hostname and private IP so we can demonstrate load-balancing\nIP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 || hostname -I | awk '{print $1}')\nHOSTNAME=$(hostname)\ncat >/var/www/html/index.html <<EOF\nHello from instance\nHostname: $HOSTNAME\nIP: $IP\nEOF\n# If nginx isn't running, start a python3 http.server fallback to serve the page\nif ! systemctl is-active --quiet nginx 2>/dev/null; then\n  if command -v python3 >/dev/null 2>&1; then\n    nohup python3 -m http.server 80 -d /var/www/html >/var/log/python-http.log 2>&1 &\n  fi\nfi\n"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ASG"
  type        = list(string)
}

variable "target_group_arns" {
  description = "List of ALB target group ARNs to attach the ASG"
  type        = list(string)
  default     = []
}

variable "asg_min_size" {
  description = "ASG minimum size"
  type        = number
}

variable "asg_max_size" {
  description = "ASG maximum size"
  type        = number
}

variable "asg_desired_capacity" {
  description = "ASG desired capacity"
  type        = number
}

variable "instance_profile_name" {
  description = "IAM instance profile name to attach to instances"
  type        = string
  default     = ""
}

variable "health_check_grace_period" {
  description = "Seconds to wait after instance launch before checking health (allows user-data to complete)"
  type        = number
  default     = 300
}
