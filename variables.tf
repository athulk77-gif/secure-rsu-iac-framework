variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "ap-south-1"
}

variable "project_prefix" {
  description = "Resource naming prefix"
  type        = string
  default     = "rsu-sec"
}

variable "alert_email" {
  description = "Email for budget alerts"
  type        = string
  default     = "athulk77@gmail.com"
}
