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

output "id" {
  description = "The ID of the EventBridge rule (same as the name)."
  value       = module.event_rule.id
}

output "arn" {
  description = "The ARN of the EventBridge rule."
  value       = module.event_rule.arn
}

output "name" {
  description = "The name of the EventBridge rule."
  value       = module.event_rule.name
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider."
  value       = module.event_rule.tags_all
}

output "event_bus_name" {
  description = "The event bus name used for tests."
  value       = coalesce(var.event_bus_name, "default")
}

output "schedule_expression" {
  description = "The configured schedule expression for test assertions."
  value       = var.schedule_expression
}
