$getPrintLog = { (Get-WinEvent -ListLog "Microsoft-Windows-PrintService/Operational").recordCount }
$importServerList = Import-Csv -Path filesystem::.\serverList.csv
$exportFileName = "serverUsePrintService.csv"
New-Item -Path filesystem::.\ -Name $exportFileName -ItemType "File" -Force

foreach ($server in $importServerList) {
  Write-Output "Entering session $($server.name)"
  $session = New-PSSession -ComputerName $server.name
  $checkIfPrintServ = Invoke-Command -ComputerName $server.name -ScriptBlock $getPrintLog
  $session | Remove-PSSession
  if (-not($checkIfPrintServ -eq $null)) {
    $server | Export-Csv -Path filesystem::.\$exportFileName -Append -Force -NoTypeInformation
  }
  Write-Output "Exited session $($server.name)"
}