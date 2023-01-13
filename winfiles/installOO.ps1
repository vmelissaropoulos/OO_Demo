$workingPath = (Get-Item $PSCommandPath).Directory
$ooInstallationFiles_Directory = Get-ChildItem $workingPath -Directory
$ooInstallationEXE_Path = Join-Path $($ooInstallationFiles_Directory.FullName) "installer-oo-win64-2021.02.exe"
$ooInstallationSilentProperties_Path = Join-Path $workingPath "silent.properties"
$installationLOG = "C:\Program Files\Micro Focus\Operations Orchestration\installer.log"

If ( (Test-Path $ooInstallationEXE_Path) -and (Test-Path $ooInstallationSilentProperties_Path) ) {
    $ooInstallationEXE_File = Get-Item $ooInstallationEXE_Path
    $ooInstallationSilentProperties_File = Get-Item $ooInstallationSilentProperties_Path 
    # $ooInstallationEXE_File
    # $ooInstallationSilentProperties_File
	Write-Host "Starting silent installation of OO"
	Write-Host "$($ooInstallationEXE_File.FullName) -s $ooInstallationSilentProperties_File"
	Write-Host "This will take some time. Please wait..."
    Invoke-Expression  "$($ooInstallationEXE_File.FullName) -s $ooInstallationSilentProperties_File"
}

$success = 0
$tries = 0
do {
	Write-Host "." -NoNewline
    $tries++
	Start-Sleep 5
	If (Test-Path $installationLOG) {
		$success = $(Select-String -Path $installationLOG -Pattern 'Start Central: success').Count
	}
} until (( $success -gt 0) -or ($tries -eq 300))

Write-Host ""
if ($tries -eq 300) {
    Write-Host "Failed to install OO. Please check log: $installationLOG"
    Exit 1
}
else {
    Write-Host "OO was installed successfully @ https://10.0.0.10:8443/oo"
}

Exit 0