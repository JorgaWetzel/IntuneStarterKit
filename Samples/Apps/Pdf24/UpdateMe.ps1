Set-ExecutionPolicy RemoteSigned

$parentFolderName = (Get-Item -Path ".\").Name
Get-ChildItem -Path ".\" -Filter *.* | ForEach-Object {
    $content = Get-Content $_.FullName
    $newContent = $content -replace 'Pdf24', $parentFolderName
    Set-Content $_.FullName $newContent
}

$parentFolderName = (Get-Item -Path ".\").Name
$searchTerm = "$parentFolderName png"
$urlEncodedSearchTerm = [System.Web.HttpUtility]::UrlEncode($searchTerm)
$searchUrl = "https://www.google.com/search?q=$urlEncodedSearchTerm"
Start-Process $searchUrl

