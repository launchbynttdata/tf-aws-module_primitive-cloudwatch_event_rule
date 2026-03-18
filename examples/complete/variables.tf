// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

# -----------------------------------------------------------------------------
# Resource Naming
# -----------------------------------------------------------------------------

variable "logical_product_family" {
  description = "Logical product family for resource naming."
  type        = string
}

variable "logical_product_service" {
  description = "Logical product service for resource naming."
  type        = string
}

variable "class_env" {
  description = "Class environment for resource naming (e.g., dev, prod)."
  type        = string
}

variable "instance_env" {
  description = "Instance environment for resource naming (numeric)."
  type        = number
}

variable "instance_resource" {
  description = "Instance resource for resource naming."
  type        = string
}

variable "resource_names_map" {
  description = "Map of key to resource_name configuration for the resource_name module."
  type = map(object({
    name       = string
    max_length = number
  }))
}

# -----------------------------------------------------------------------------
# Event Rule
# -----------------------------------------------------------------------------

variable "name" {
  description = "The name of the rule. If omitted, uses resource_names generated name. Conflicts with name_prefix."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name. Must be 38 characters or less."
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the rule."
  type        = string
  default     = null
}

variable "schedule_expression" {
  description = "The scheduling expression. At least one of schedule_expression or event_pattern is required."
  type        = string
  default     = null
}

variable "event_pattern" {
  description = "The event pattern described as a JSON object. At least one of schedule_expression or event_pattern is required."
  type        = string
  default     = null
}

variable "event_bus_name" {
  description = "The name or ARN of the event bus to associate with this rule."
  type        = string
  default     = null
}

variable "role_arn" {
  description = "The ARN associated with the role used for target invocation."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Used to delete managed rules created by AWS."
  type        = bool
  default     = false
}

variable "state" {
  description = "State of the rule. Valid values are DISABLED, ENABLED, and ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS."
  type        = string
  default     = "ENABLED"
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
