pipeline {
    agent any
    environment {
        AZURE_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        AZURE_TENANT_ID       = credentials('AZURE_TENANT_ID')
        AZURE_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        GRAPH_CLIENT_ID       = credentials('GRAPH_CLIENT_ID')
        GRAPH_CLIENT_SECRET   = credentials('GRAPH_CLIENT_SECRET')
    }
    triggers {
        cron('H H(2-4) * * *') // Runs daily between 2–4 AM
    }
    stages {
        stage('Login to Azure') {
            steps {
                powershell '''
                    az login --service-principal -u $env:AZURE_CLIENT_ID -p $env:AZURE_CLIENT_SECRET --tenant $env:AZURE_TENANT_ID
                    az account set --subscription $env:AZURE_SUBSCRIPTION_ID
                '''
            }
        }

        stage('Run Cleanup Script') {
            steps {
                powershell './cleanup.ps1'
            }
        }

        stage('Send Email Report') {
            steps {
                powershell './sendReport.ps1'
            }
        }
    }
}
