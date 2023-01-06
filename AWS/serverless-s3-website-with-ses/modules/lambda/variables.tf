variable "allowed_triggers" {
  description = "Map of allowed triggers to create Lambda permissions"
  type        = map(any)
  default     = {}
}

variable "attach_policy_statements" {
  description = "Controls whether policy_statements should be added to IAM role for Lambda Function"
  type        = bool
  default     = false
}

variable "create_role" {
  description = "Controls whether IAM role for Lambda Function should be created"
  type        = bool
  default     = true
}

variable "description" {
  description = "Description of your Lambda Function (or Layer)"
  type        = string
  default     = ""
}

variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
  default     = ""
}

variable "handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
  default     = ""
}

variable "policy_statements" {
  description = "Map of dynamic policy statements to attach to Lambda Function role"
  type        = any
  default     = {}
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version."
  type        = bool
  default     = false
}

variable "role_name" {
  description = "Name of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
  default     = ""
}

variable "source_path" {
  description = "The absolute path to a local file or directory containing your Lambda source code"
  type        = any
  default     = null
}
