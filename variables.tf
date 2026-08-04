variable "project_name" {
  description = "Unique name used as a prefix for AWS resources"
  type        = string
  default     = "project-crr-2026"
}

variable "primary_region" {
  description = "AWS Region for the primary S3 bucket"
  type        = string
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "AWS Region for the secondary S3 bucket"
  type        = string
  default     = "eu-west-1"
}