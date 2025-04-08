pipeline {
    agent any

    environment {
        AZURE_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        AZURE_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        AZURE_TENANT_ID       = credentials('AZURE_TENANT_ID')
        AZURE_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
    }

    triggers {
        cron('H H * * *')  // runs daily at random hour to balance Jenkins load
    }

    stages {
        stage('Cleanup Azure Resources') {
            steps {
                writeFile file: 'azure_cleanup.ps1', text: '''
                    az login --service-principal -u $env:AZURE_CLIENT_ID -p $env:AZURE_CLIENT_SECRET --tenant $env:AZURE_TENANT_ID
                    az account set --subscription $env:AZURE_SUBSCRIPTION_ID

                    # Sample: List orphan disks
                    $orphanDisks = az disk list --query "[?managedBy==null]" -o table
                    Write-Output "Orphan Disks: $orphanDisks"
                '''

                powershell script: './azure_cleanup.ps1'
            }
        }
    }
}
