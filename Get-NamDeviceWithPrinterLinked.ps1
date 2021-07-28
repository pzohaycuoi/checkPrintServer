$importServerList = Import-Csv -Path filesystem::.\serverList2.csv
$exportFileName = "serverUseWithPrinterLinked.csv"
New-Item -Path filesystem::.\ -Name $exportFileName -ItemType "File" -Force

foreach ($server in $importServerList) {
  Write-Output "Getting computer's printer information: $($server.name)"
  $checkIfPrintServ = Get-Printer -ComputerName $server.name | Where Shared -eq $true
  if (-not($checkIfPrintServ -eq $null)) {
    $server | Export-Csv -Path filesystem::.\$exportFileName -Append -Force -NoTypeInformation
    Write-Output "Server $($server.name) have printer connected."
  }
  Write-Output "Exit $($server.name)"
  Write-Output "#-----------------------------#"
}