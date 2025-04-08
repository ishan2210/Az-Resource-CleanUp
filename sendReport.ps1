$clientId = $env:GRAPH_CLIENT_ID
$clientSecret = $env:GRAPH_CLIENT_SECRET
$tenantId = $env:AZURE_TENANT_ID
$body = @{
    grant_type    = "client_credentials"
    client_id     = $clientId
    client_secret = $clientSecret
    scope         = "https://graph.microsoft.com/.default"
}
$token = Invoke-RestMethod -Method POST -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Body $body
$headers = @{
    Authorization = "Bearer $($token.access_token)"
    Content-Type  = "application/json"
}

$report = Get-Content -Raw -Path cleanup_report.txt
$emailBody = @{
    message = @{
        subject = "Azure Orphan Resource Cleanup Report"
        body = @{
            contentType = "Text"
            content     = $report
        }
        toRecipients = @(
            @{ emailAddress = @{ address = "devops@example.com" } }
        )
    }
    saveToSentItems = "false"
}

Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/users/devops@example.com/sendMail" `
                  -Method POST -Headers $headers -Body ($emailBody | ConvertTo-Json -Depth 4)
