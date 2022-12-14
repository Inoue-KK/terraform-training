variable "project_unique_id" {}

variable "allowed_ipaddr_list" {
  type    = list(string)
  default = ["127.0.0.1/8"]
}

# aws
variable "base_dnsdomain" {
  default = "example.dev"
}

variable "aws_default_region" {
  default = "us-east-1"
}
variable "aws_access_key" {}
variable "aws_secret_key" {}

# azure
variable "azure_default_location" {
  default = "centralus"
}

# google
variable "gcp_default_region" {
  default = "us-central1"
}
variable "gcp_project_id" {}
variable "firewall_tags" {
  default = {
    firewall-ingress-allow-from-allowed-list = "firewall-ingress-allow-from-allowed-list"
  }
}