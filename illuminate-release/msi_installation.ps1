$releasePath = Split-Path -Path $PWD -Parent
$packagesPath = $releasePath+"\packages\"
$logPath = $releasePath+"\logs\"

$packagesFiles = Get-ChildItem $packagesPath

foreach ($file in $packagesFiles){
    $logFile = '{0}{1}.log' -f $logPath, $file
    $msiArguments = '/i {0}{1} /L*V {2}' -f $packagesPath, $file, $logFile
    Write-Host $msiArguments
    Start-Process "msiexec.exe" -ArgumentList $msiArguments -Wait
}
