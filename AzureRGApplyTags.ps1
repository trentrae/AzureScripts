Connect-AzAccount -Environment AzureUSGovernment
# This can be modified based on your requirement.
$TagFilePath="$($currentDir)\tags.csv"
  
#You can modify the path here based on your requirements.
$ResourceToTagFilePath="$($currentDir)\List_Of_All_Azure_Resources_$($date).csv"
   
function convertCsvToHashTable($csvFile){
    $csv=import-csv $csvFile
    $headers=$csv[0].psobject.properties.name
    $key=$headers[0]
    $value=$headers[1]
    $hashTable = @{}
    $csv | % {$hashTable[$_."$key"] = $_."$value"}
    return $hashTable
}
 $TagsHashTable=@{}
$TagsHashTable=convertCsvToHashTable $TagFilePath
  $csv = import-csv $ResourceToTagFilePath
  
$csv | ForEach-Object {
    Write-Host "  $($_.RESOURCE_GROUP_NAME), $($_.SUBSCRIPTION_ID ) "
   Set-AzContext $_.SUBSCRIPTION_ID
  
   $resource = Get-AzResourceGroup  -Name  $_.RESOURCE_GROUP_NAME
      
 
   write-Host "$resource.ResourceId"
   Update-AzTag -ResourceId $resource.ResourceId -Tag $TagsHashTable -Operation Merge
 }
