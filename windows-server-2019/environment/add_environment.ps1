[string[]]$arrayFromFile = Get-Content -Path 'C:\IlluminateRelease\220419-illuminate-release\scripts\environment.conf'

foreach ($element in $arrayFromFile){
  $keyPair = $element.Split("|")
  [System.Environment]::SetEnvironmentVariable($keyPair[0], $keyPair[1], [System.EnvironmentVariableTarget]::Machine)
}
