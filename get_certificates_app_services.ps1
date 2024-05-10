# Connect to your Azure account
Connect-AzAccount -Tenant <your tenant>

# Set the output CSV file name and destination
$outputFile = "C:\Temp\WebApps_Certificates.csv"

# # Initialize a list to store results
$results = @()

# Get all Subscription
$subscriptions = Get-AzSubscription

# Looping on each subscription
foreach ($subscription in $subscriptions) {
    # Select current subscription
    Select-AzSubscription -SubscriptionId $subscription.Id

    # Get all Web Apps in current subscription
    $webApps = Get-AzWebApp

    # Looping about each Web App and obtain the associated certificates
    foreach ($webApp in $webApps) {
        # Getting WebApp certificate settings
        $certificates = Get-AzWebAppCertificate -ResourceGroupName $webApp.ResourceGroup

        # Lopping about each certificate for details
        foreach ($cert in $certificates) {
            $result = New-Object PSObject -Property @{
                "WebAppName" = $webApp.Name
                "ResourceGroupName" = $webApp.ResourceGroup
                "CertificateThumbprint" = $cert.Thumbprint
                "CertificateName" = $cert.Name
                "ExpirationDate" = $cert.ExpirationDate
                "SubscriptionId" = $subscription.Id
                "SubscriptionName" = $subscription.Name
            }
            $results += $result
        }
    }
}

# Export results to a CSV file
$results | Export-Csv -Path $outputFile -NoTypeInformation

Write-Host "O arquivo CSV foi gerado com sucesso: $outputFile"