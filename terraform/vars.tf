variable "token" {}
variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "admin_public_key" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGlu0zm0sm0UEUSjB1p8P69G3zMnk9MApZbfKjGGpVsPtrsJeyPu88GRvgGk2jXLmnqHvbZXELwPm3V5n1XbSRMiooRHprRseyzyt4rlxVzootnqXf2vPUcLGqIkg6KBSlMF03pj1m9KEo7za6Zza4sULLHe7lc4aDYa2JgDQ6Xt+lw88C8CH8NInOUSgU+x5An1ywAlDyrCpbxTq55mlvZVMLLi3BnaGnd6cyDG4M2SgTtU6CesV5cAveXCxOzBq3ymS/CPUGlQaW9FsgtW67OpxEWOvsVNuT1zbh6XDlAWWfcvft66hxChXduMqfGe8Iu6y8RB+jQz9LU6SR3uBnfAYjVQeigGeJw85/GgC6fKqh8My0JCMqmPb+uI6sKo7En+jX1U7ubOcMfh9mndClvoq0GE6R8uocld2QSU2OiMFzuDvn6CitGV6VoYsB65KcUXMBeaIVU6nYDrLPTM4kiki8bicOjZ4K+RJRvRinxbKYnSXzyhrftfTX7Nlp1ehfNCougzWtPaxSM9sr6Et9XIOW3CV6lDfPj8X2IZFIBxaiJIb9d6Nsc548l5XKEATEkCnvF8ZDBjQ7olImpQlzPcRuOis3l6oNNj3Ajdhzfw3SWcTmmGib5m0UQsdFPCWZX+soj0Rhe4WMUn9MJ88PlaF55VeovYSaLR5EQm/nCQ== admin key"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "az_qty" {
  description = "Number of zones into region"
  default     = "2"
}

variable "admin_cidr" {
  description = "CIDR to allow tcp/22 ingress to ecs instances"
}

variable "instance_type" {
  default     = "t2.small"
  description = "AWS instance type"
}

variable "asg_min" {
  description = "Min qty of servers in ASG"
  default     = "1"
}

variable "asg_max" {
  description = "Max qty of servers in ASG"
  default     = "2"
}

variable "asg_desired" {
  description = "Desired qty of servers in ASG"
  default     = "1"
}
