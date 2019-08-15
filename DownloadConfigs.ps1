#DownloadConfigs by James Preston of ANSecurity (https://www.ansecurity.com), v1.0
#See https://github.com/jamesfed/BackupPANNGFWConfig for useage

#Use TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Config options - change these paths if required
$SavePath = "C:\PaloExport"
$ListOfNGFWs = "$SavePath\ListOfNGFWs.csv"

#Import List of NGFWs
try {
    $NGFWs = Import-Csv $ListOfNGFWs
}
catch {
    throw "Could not load NGFW CSV from $SavePath\ListOfNGFWs.csv"
}

#Get a Date/Time Stamp
$DTG = Get-Date -Format "yyyy-M-d HHmm"

#Loop over the CSV
foreach($NGFW in $NGFWs){

    #Test if the folder for the NGFW exisits and if not create it
    if((Test-Path $SavePath\Backups\$($NGFW.Hostname)) -eq $False){
        Write-Host "Folder $SavePath\Backups\$($NGFW.Hostname) does not exist, creating it"
        New-Item -Path $SavePath\Backups\$($NGFW.Hostname) -ItemType Directory | Out-Null
    }

    #Test if the folder for the backup DTG exisits and if not create it
    if((Test-Path $SavePath\Backups\$($NGFW.Hostname)\$DTG) -eq $False){
        Write-Host "Folder $SavePath\Backups\$($NGFW.Hostname)\$DTG does not exist, creating it"
        New-Item -Path $SavePath\Backups\$($NGFW.Hostname)\$DTG -ItemType Directory | Out-Null
    }

    #Download the candidate configuration
    Write-Host "Downloading candidate configuration"
    Invoke-WebRequest -Uri "https://$($NGFW.Hostname)/api/?type=export&category=configuration&key=$($NGFW.APIKey)" -OutFile $SavePath\Backups\$($NGFW.Hostname)\$DTG\CandidateConfiguration.xml
    #Download the device state (which includes running-config.xml)
    Write-Host "Downloading device state"
    Invoke-WebRequest -Uri "https://$($NGFW.Hostname)/api/?type=export&category=device-state&key=$($NGFW.APIKey)" -OutFile $SavePath\Backups\$($NGFW.Hostname)\$DTG\DeviceState.tgz
}