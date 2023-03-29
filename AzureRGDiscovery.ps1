Connect-AzAccount -Environment AzureUSGovernment

##Discovery of All Resource Groups and output to file
$date = Get-Date -UFormat("%m-%d-%y")
$currentDir = $(Get-Location).Path
$oFile = "$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
  
if(Test-Path $oFile){
    Remove-Item $oFile -Force
}
  
"SUBSCRIPTION_NAME,SUBSCRIPTION_ID, RESOURCE_GROUP_NAME" | Out-File $oFile -Append -Encoding ascii
  
Get-AzSubscription | ForEach-Object{
    $subscriptionId = $_.Id
    $subscriptionName = $_.Name
      
    Set-AzContext -SubscriptionId $subscriptionId
    Get-AzResourceGroup | ForEach-Object{
        $resourceGroupName = $_.ResourceGroupName
                     
              
            "$subscriptionName,$subscriptionId,$resourceGroupName" | Out-File $oFile -Append -Encoding ascii
        }
    }
