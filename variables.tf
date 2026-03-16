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
# Naming
# -----------------------------------------------------------------------------

variable "name" {
  description = "The name of the rule. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name. Must be 38 characters or less."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null ? true : length(var.name_prefix) <= 38
    error_message = "name_prefix must be 38 characters or less."
  }
}

# -----------------------------------------------------------------------------
# Rule Definition
# -----------------------------------------------------------------------------

variable "schedule_expression" {
  description = "The scheduling expression. For example, cron(0 20 * * ? *) or rate(5 minutes). At least one of schedule_expression or event_pattern is required. Can only be used on the default event bus."
  type        = string
  default     = null
}

variable "event_pattern" {
  description = "The event pattern described as a JSON object. At least one of schedule_expression or event_pattern is required."
  type        = string
  default     = null
}

variable "event_bus_name" {
  description = "The name or ARN of the event bus to associate with this rule. If omitted, the default event bus is used."
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the rule."
  type        = string
  default     = null
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) associated with the role that is used for target invocation."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Used to delete managed rules created by AWS."
  type        = bool
  default     = false
}

variable "state" {
  description = "State of the rule. Valid values are DISABLED, ENABLED, and ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS. ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS cannot be used with schedule_expression."
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["DISABLED", "ENABLED", "ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS"], var.state)
    error_message = "State must be DISABLED, ENABLED, or ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS."
  }
}

# -----------------------------------------------------------------------------
# Tags
# -----------------------------------------------------------------------------

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
