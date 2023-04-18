variable "town_hall_vpc" {
  type        = string
  default     = "10.20.0.0/16"
  description = "default company VPC"
}

variable "DMZPublic1_subnet_cidr" {
  type        = list
  default     = ["10.10.32.0/19, 10.20.96.0/19"]
  description = "Public DMZ subnet CIDR"
}
variable "AppLayer_private_cidr" {
  type        = list
  default     = ["10.20.128.0/19, 10.20.160.0/19"]
  description = "Private App layer subnet CIDR"
}
variable "DB_private_cidr" {
  type        = list
  default     = ["10.20.192.0/19, 10.20.224.0/19"]
  description = "Private DB subnet CIDR"
}

variable "avail_zones" {
  type        = list
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "description"
}








