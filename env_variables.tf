variable "dev_mode" {
  description = "If true, auto scaling was suspended, autoscaling policy was disabled  "
  type        = bool
  default     = false
}

variable "aws_account_id" {
  description = "resource owner"
  type        = string
  default     = ""
}

variable "owner" {
  description = "resource owner"
  type        = string
  default     = "DevOps"
}
variable "environment" {
  description = "The IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
  type        = string
  default     = ""
}

variable "region" {
  description = "aws region"
  type        = string
  default     = "ap-southeast-2"
}

variable "application" {
  description = "application name, use for tag"
  type        = string
  default     = "autoscaling"
}

variable "service" {
  description = "own service name, use for tag"
  type        = string
  default     = "app"

}

variable "snow_guid" {
  description = "SNOW_GUID, use for tag"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "own domain name i.e own-pliot.ampaws.com.au, to get certificate or setuo dns"
  type        = string
  default     = ""
}


variable "certificate_arn" {
  description = "aws certificate for own tenants"
  type        = string
  default     = ""
}


variable "snsemail" {
  description = "own-SNSEmailOnlyXMatters Topic"
  type        = string
  default     = ""
}

variable "snsmessage" {
  description = "own-SNSXMatters Topic, mainly for prod."
  type        = string
  default     = ""
}

variable "s3_installation_bucket" {
  description = "s3  installation bukect."
  type        = string
  default     = ""
}

