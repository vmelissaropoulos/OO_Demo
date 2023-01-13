$workingPath = (Get-Item $PSCommandPath).Directory
$ooZIP = Get-Item (Get-ChildItem $workingPath -Filter *.zip)
$ooInstallationFiles = Join-Path $ooZIP.Directory $oozip.BaseName

If (Test-Path $ooInstallationFiles) { 
    $ooInstallationFiles_Directory = Get-Item $oozip.BaseName

    Write-Host "Folder $ooInstallationFiles_Directory already exist! Removing it..."
    Remove-Item $ooInstallationFiles_Directory -Recurse -Force
}

If (-not (Test-Path $ooInstallationFiles)) {
    Expand-Archive $ooZIP -DestinationPath $oozip.BaseName -Verbose -Force
}

Write-Host "Completed successfully!"