# Conecte-se à sua conta do Azure
Connect-AzAccount -Tenant <your tenant> -Subscription <your subscription>

# Obter todos os grupos de recursos na assinatura
$resourceGroups = Get-AzResourceGroup

# Criar uma lista para armazenar os resultados
$webAppList = @()

# Iterar sobre cada grupo de recursos
foreach ($resourceGroup in $resourceGroups) {
    # Obter todos os WebApps no grupo de recursos atual
    $webApps = Get-AzWebApp -ResourceGroupName $resourceGroup.ResourceGroupName

    # Iterar sobre cada WebApp
    foreach ($webApp in $webApps) {
        # Obter o nome do WebApp
        $webAppName = $webApp.Name
        $ResourceGroupName = $webApp.ResourceGroup
        
        # Obter as configurações de restrição de acesso
        $accessRestrictions = Get-AzResource -ResourceType "Microsoft.Web/sites/config" -ResourceGroupName $resourceGroup.ResourceGroupName -ResourceName "$webAppName/web" -ApiVersion "2018-11-01" | Select-Object -ExpandProperty Properties

        # Verificar se há regras de IP
        if ($accessRestrictions.ipSecurityRestrictions -ne $null) {
            # Iterar sobre cada regra de IP
            foreach ($ipRule in $accessRestrictions.ipSecurityRestrictions) {
                # Adicionar detalhes à lista
                $webAppDetails = @{
                    "Nome do WebApp" = $webAppName
                    "Rule Name"      = $ipRule.name
                    "IP Restrito"    = $ipRule.ipAddress
                    "Public Access"  = $accessRestrictions.publicNetworkAccess
                    "Action"         = $ipRule.action
                    "Resource Group" = $ResourceGroupName
                }
                $webAppList += New-Object PSObject -Property $webAppDetails
            }
        } 
    }
}

# Exportar para CSV
$webAppList | Export-Csv -Path "C:\Temp\Weapp_IpsRestriction_test.csv" -NoTypeInformation

Write-Host "Exportação concluída"
