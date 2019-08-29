#GenerateAPIKey by James Preston of ANSecurity (https://www.ansecurity.com), v1.0
#See https://github.com/jamesfed/BackupPANNGFWConfig for useage

#Use TLS1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Change these values to match the hostname of the NGFW, you may want to create a dedicated apiadmin account (Superuser (read-only) has the correct permissions required)
$PaloAddress = 'ngfw.example.com'
$PaloUser = 'apiadmin'
$PaloPass = 'PasswordsAreBestWhenTheyAreThreeRandomWordsOrMore'

#Get a API key and transform the result
$CredsOutput = Invoke-WebRequest -Uri "https://$PaloAddress/api/?type=keygen&user=$PaloUser&password=$PaloPass"
[xml]$ContentResponse = $CredsOutput.Content
$Key = $ContentResponse.response.result.key

#Output the API key to the host
Write-Host "Your API Key is below, please add it to the ListOfNGFWs.csv to use it with the backup script"
$($Key | Out-String).Trim() | Write-Host
