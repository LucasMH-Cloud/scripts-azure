# Conectando-se à sua conta do Azure
Connect-AzAccount -Tenant 812a6bd0-5829-4196-b2be-d0580b7bd0cb -Subscription f9766fcb-30d2-4992-b2ea-c39cbfd71fe9

# Definindo detalhes da assinatura e do recurso
#$resourceGroupName = "prd-us-nwc-rg"
$outputCsvPath = "C:\Temp\WebApp_Slot_AccessRestrictions.csv"
# Obter todos os grupos de recursos na assinatura
$resourceGroups = Get-AzResourceGroup
#$appServices = Get-AzWebApp -ResourceGroupName $resourceGroupName

# Criando um array para armazenar os dados das restrições de acesso
$accessRestrictionsData = @()

foreach ($resourceGroup in $resourceGroups){
    $appServices = Get-AzWebApp -ResourceGroupName $resourceGroup.ResourceGroupName

    # Iterando por cada aplicativo da web
    foreach ($appService in $appServices) {
        
        # Obtendo os slots do aplicativo da web
        $slots = Get-AzWebAppSlot -ResourceGroupName $resourceGroup.ResourceGroupName -Name $appService.Name
        foreach ($slot in $slots) {
            $slotsNames = $slot.Name.split('/')
            $slotsNamesResults = $slotsNames[1]       
            
            foreach ($slotNameResult in $slotsNamesResults) {
                # Obtendo os slots do aplicativo da web
                $slotsResult = Get-AzWebAppSlot -ResourceGroupName $resourceGroup.ResourceGroupName -Name $appService.Name -Slot $slotNameResult
                $accessRestriction = $slotsResult.SiteConfig.IpSecurityRestrictions
               
                # Loop através das restrições de acesso e adicionando ao array
                foreach ($restriction in $accessRestriction) {
                    $accessRestrictionResult = [PSCustomObject]@{
                        ResourceGroup = $resourceGroup.ResourceGroupName
                        "Name WebApp Slot" = $slotsNames
                        "Rule Name"   = $restriction.Name
                        IpAddress     = $restriction.IPAddress
                        Action        = $restriction.Action
                        Priority      = $restriction.Priority
                    }
                    $accessRestrictionsData += $accessRestrictionResult   
                }
            }
        }
    }
}   
# Exportando os dados para um arquivo CSV
$accessRestrictionsData | Export-Csv -Path $outputCsvPath -NoTypeInformation

Write-Host "As restrições de acesso foram exportadas com sucesso para: $outputCsvPath"