$workingDir = (Get-Item $PSCommandPath).Directory
$ooZIP_Path = Join-Path $env:USERPROFILE "\Downloads\oo-2021.02.1.0_PH_196413.zip"
$ooZIP_Hash = "1602CD8612B0C6A3AAC61787A14EDDE9683B8F0E9177A3A733B3981DDD4C9B62"
$ooZIP_DownloadPage = "https://performancetechnologiesgr-my.sharepoint.com/:u:/g/personal/v_melissaropoulos_performance_gr/ESMrfH0KqHRKq7GP9tAqEGAB5ODulFY0q1j9QtZQbOjyTQ?e=S1SHjV"
$ooZIP_DownloadLink = "https://performancetechnologiesgr-my.sharepoint.com/personal/v_melissaropoulos_performance_gr/_layouts/15/download.aspx?SourceUrl=%2Fpersonal%2Fv%5Fmelissaropoulos%5Fperformance%5Fgr%2FDocuments%2FMF%5FInstallation%5FFiles%2FOO%2Foo%2D2021%2E02%2E1%2E0%5FPH%5F196413%2Ezip"

if (-not $(Test-Path $ooZIP_Path)) {
    Start-Process -WindowStyle Minimized -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList @($ooZIP_DownloadPage)
    Start-Sleep 5
    Start-Process -WindowStyle Minimized -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" -ArgumentList @($ooZIP_DownloadLink) -Wait

    Write-Host "Downloading OO from OneDrive. This might take some time..."
    While (-not $(test-path $ooZIP_Path)) {
       Start-Sleep 5
    }
    
    TaskKill /im msedge.exe /f /t
}
else {
    Write-Host "File already exists!"
}


Write-Host "Checking file integrity.."
$ooZIP_File = Get-item $ooZIP_Path
$ooZIP_FileHash = (Get-FileHash $ooZIP_File).Hash

If ($ooZIP_Hash -eq $ooZIP_FileHash) {
    Write-Host "File hash is correct! Moving file to $workingDir ..."
    Move-Item $ooZIP_File $workingDir -Force -Verbose
}
Else {
    Write-Host "File hash is not correct! File's integrity cannot be confirmed! Removing file and aborting..."
    Remove-Item $ooZIP_File
}