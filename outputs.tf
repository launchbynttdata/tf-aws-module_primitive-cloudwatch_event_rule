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
  description = "The ID of the resource (same as the name)."
  value       = aws_cloudwatch_event_rule.rule.id
}

output "arn" {
  description = "The ARN of the rule."
  value       = aws_cloudwatch_event_rule.rule.arn
}

output "name" {
  description = "The name of the rule."
  value       = aws_cloudwatch_event_rule.rule.name
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider."
  value       = aws_cloudwatch_event_rule.rule.tags_all
}
