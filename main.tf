resource "genesyscloud_integration_action" "action" {
    name           = var.action_name
    category       = var.action_category
    integration_id = var.integration_id
    secure         = var.secure_data_action
    
    contract_input  = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "additionalProperties" = true,
        "description" = "A request for the customer call start datetime",
        "properties" = {
            "ConversationID" = {
                "description" = "Conversation/interaction ID",
                "type" = "string"
            }
        },
        "required" = [
            "ConversationID"
        ],
        "type" = "object"
    })
    contract_output = jsonencode({
        "$schema" = "http://json-schema.org/draft-04/schema#",
        "additionalProperties" = true,
        "description" = "Returns datetime in UTC.",
        "properties" = {
            "StartDateTime" = {
                "description" = "Call start DateTimeUTC",
                "type" = "string"
            }
        },
        "title" = "Get Members of queue",
        "type" = "object"
    })
    
    config_request {
        request_template     = "$${input.rawRequest}"
        request_type         = "GET"
        request_url_template = "/api/v2/conversations/$${input.ConversationID}"
        headers = {
			UserAgent = "PureCloudIntegrations/1.0"
			Content-Type = "application/json"
		}
    }

    config_response {
        success_template = "{\n   \"StartDateTime\": $${startTime}\n}"
        translation_map = { 
			startTime = "$.startTime"
		}
               
    }
}