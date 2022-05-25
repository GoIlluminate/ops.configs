Install-Module -Name SqlServer -Force

$baseDir = Split-Path $MyInvocation.MyCommand.Path
$baseDrive = Split-Path $MyInvocation.MyCommand.Path -Qualifier

# Create Data Directories

$dbDataDir = "C:\Illuminate\IlluminateDatabase\Data"
$dbBackupDir = "C:\Illuminate\IlluminateDatabase\Backup"

New-Item -ItemType Directory -Force -Path $dbDataDir
New-Item -ItemType Directory -Force -Path $dbBackupDir

# Create Illuminate Databases

$dbScriptPath = $baseDir + "\illum-create-database.sql"
$dmScriptPath = $baseDir + "\illum-create-datamart.sql"
$cubeScriptPath = $baseDir + "\illum-create-cube.xmla"


# Import SQLPS Module (which is not yet visible in this session)

$env:PSModulePath = $env:PSModulePath + ";C:\Program Files (x86)\Microsoft SQL Server\110\Tools\PowerShell\Modules\"

Import-Module "SQLPS"


# Create databases

Invoke-SqlCmd -InputFile $dbScriptPath -Variable "dbname=IlluminateAdmin", "dbpath=$dbDataDir"
Invoke-SqlCmd -InputFile $dbScriptPath -Variable "dbname=IlluminateAudit", "dbpath=$dbDataDir"
Invoke-SqlCmd -InputFile $dbScriptPath -Variable "dbname=IlluminateDb", "dbpath=$dbDataDir"

Invoke-SqlCmd -InputFile $dmScriptPath -Variable "dbname=ClinicalDataMart", "dbpath=$dbDataDir"

Invoke-ASCmd -InputFile $cubeScriptPath -Server . -Variable "dbname=IlluminateAnalytics", "dmhost=(local)", "dmname=ClinicalDataMart" 


# Create Analytics User and Group

$computer = [ADSI]"WinNT://$Env:COMPUTERNAME,Computer"

$group = $computer.Create("Group", "Illuminate Analytics Users")
$group.SetInfo()

$user = $computer.Create("User", "IllumAnalyticsUser")
$user.SetPassword("Illuminate1!");
$user.SetInfo()
$user.FullName = "IllumAnalyticsUser"
$user.UserFlags = 65536 # ADS_UF_DONT_EXPIRE_PASSWORD
$user.SetInfo()

$group.Add($user.Path)
$group.SetInfo()


# Add Analytics Group to "Data Readers" Role

Add-RoleMember -Server . -MemberName "$ENV:COMPUTERNAME\Illuminate Analytics Users" -Database "IlluminateAnalytics" -RoleName "Data Readers"
