variable "CandidateName" {
  description = "Please fill in your name below"
  default     = "eiji-kumamoto"
}

variable "vpc_cidr" {
  description = "Use it to determine which CIDR block you want to use"
  default     = "10.0.10.0/24"
}

variable "vpc_cidr_private_subnet_1a" {
  description = "Private Subnet CIDR for AZ A"
  default     = "10.0.10.0/26"
}

variable "vpc_cidr_private_subnet_1b" {
  description = "Private Subnet CIDR for AZ B"
  default     = "10.0.10.64/26"
}

variable "vpc_cidr_public_subnet_1a" {
  description = "Public Subnet CIDR for AZ A"
  default     = "10.0.10.128/26"
}

variable "vpc_cidr_public_subnet_1b" {
  description = "Public Subnet CIDR for AZ B"
  default     = "10.0.10.192/26"
}
