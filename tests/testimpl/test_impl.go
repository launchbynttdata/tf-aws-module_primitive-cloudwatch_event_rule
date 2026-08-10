package testimpl

import (
	"context"
	"encoding/json"
	"strings"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/eventbridge"
	eventbridgetypes "github.com/aws/aws-sdk-go-v2/service/eventbridge/types"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	t.Run("VerifyTerraformOutputs", func(t *testing.T) {
		ruleName := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "name")
		ruleArn := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "arn")
		ruleId := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "id")

		assert.Equal(t, ruleName, ruleId, "id should equal name for EventBridge rules")
		assert.NotEmpty(t, ruleArn, "ARN should be set")
		require.Contains(t, ruleArn, "arn:aws:events:", "ARN should be a valid EventBridge rule ARN")
	})

	t.Run("VerifyRuleViaAWSAPI", func(t *testing.T) {
		ruleArn := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "arn")
		region := parseRegionFromEventBridgeARN(t, ruleArn)
		eventBusName := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "event_bus_name")
		scheduleExpression := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "schedule_expression")

		cfg, err := config.LoadDefaultConfig(context.Background(), config.WithRegion(region))
		require.NoError(t, err)

		client := eventbridge.NewFromConfig(cfg)
		ruleName := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "name")

		output, err := client.DescribeRule(context.Background(), &eventbridge.DescribeRuleInput{
			Name:         aws.String(ruleName),
			EventBusName: aws.String(eventBusName),
		})
		require.NoError(t, err)
		require.NotNil(t, output)

		expectedState := "ENABLED"
		assert.Equal(t, expectedState, string(output.State), "Rule state should be ENABLED")
		assert.Equal(t, scheduleExpression, aws.ToString(output.ScheduleExpression), "Schedule expression should match")

		expectedArn := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "arn")
		assert.Equal(t, expectedArn, *output.Arn, "ARN from API should match Terraform output")
	})

	t.Run("VerifyRuleAcceptsEvents", func(t *testing.T) {
		ruleArn := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "arn")
		region := parseRegionFromEventBridgeARN(t, ruleArn)
		eventBusName := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "event_bus_name")

		cfg, err := config.LoadDefaultConfig(context.Background(), config.WithRegion(region))
		require.NoError(t, err)

		client := eventbridge.NewFromConfig(cfg)

		detail, _ := json.Marshal(map[string]string{"source": "terratest", "action": "verify"})
		putEventsOutput, err := client.PutEvents(context.Background(), &eventbridge.PutEventsInput{
			Entries: []eventbridgetypes.PutEventsRequestEntry{
				{
					Source:       aws.String("terratest.verify"),
					DetailType:   aws.String("TerratestVerification"),
					Detail:       aws.String(string(detail)),
					EventBusName: aws.String(eventBusName),
				},
			},
		})
		require.NoError(t, err)
		assert.Zero(t, putEventsOutput.FailedEntryCount, "PutEvents should not report failed entries")
	})
}

func TestComposableCompleteReadonly(t *testing.T, ctx types.TestContext) {
	t.Run("VerifyTerraformOutputs", func(t *testing.T) {
		ruleName := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "name")
		ruleArn := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "arn")
		ruleId := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "id")

		assert.Equal(t, ruleName, ruleId, "id should equal name for EventBridge rules")
		assert.NotEmpty(t, ruleArn, "ARN should be set")
		require.Contains(t, ruleArn, "arn:aws:events:", "ARN should be a valid EventBridge rule ARN")
	})

	t.Run("VerifyRuleViaAWSAPI", func(t *testing.T) {
		ruleArn := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "arn")
		region := parseRegionFromEventBridgeARN(t, ruleArn)
		eventBusName := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "event_bus_name")
		scheduleExpression := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "schedule_expression")

		cfg, err := config.LoadDefaultConfig(context.Background(), config.WithRegion(region))
		require.NoError(t, err)

		client := eventbridge.NewFromConfig(cfg)
		ruleName := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "name")

		output, err := client.DescribeRule(context.Background(), &eventbridge.DescribeRuleInput{
			Name:         aws.String(ruleName),
			EventBusName: aws.String(eventBusName),
		})
		require.NoError(t, err)
		require.NotNil(t, output)

		expectedState := "ENABLED"
		assert.Equal(t, expectedState, string(output.State), "Rule state should be ENABLED")
		assert.Equal(t, scheduleExpression, aws.ToString(output.ScheduleExpression), "Schedule expression should match")

		expectedArn := terraform.OutputContext(t, context.Background(), ctx.TerratestTerraformOptions(), "arn")
		assert.Equal(t, expectedArn, *output.Arn, "ARN from API should match Terraform output")
	})
}

func parseRegionFromEventBridgeARN(t *testing.T, arn string) string {
	t.Helper()
	parts := strings.Split(arn, ":")
	require.GreaterOrEqual(t, len(parts), 4, "ARN must have at least 4 parts: %s", arn)
	return parts[3]
}
