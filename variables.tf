variable "additional_tags" {
  description = "Map for adding extra optional tags"
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "Unique Name of the S3 bucket to be created"
  type        = string
  validation {
    condition     = can(regex("^[0-9]{12}-([a-z0-9]+-)+[a-z0-9]+$", var.bucket_name))
    error_message = "S3 bucket name must follow the naming convention <account_id>-<component/service>-<purpose>, where service and purpose can be more than one words each, separated by dashes."
  }
  validation {
    condition     = length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "The S3 bucket name must be between 3 and 63 characters long."
  }
}

variable "tags" {
  type = object({
    OrgUnit            = string
    Environment        = string
    ModuleName         = string
    ServiceName        = optional(string)
    Squad              = string
    DataClassification = string
    Owner              = string
    DeploymentType     = string
    CostCenter         = string
  })
}
