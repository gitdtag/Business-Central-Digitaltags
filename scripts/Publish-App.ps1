﻿Param(
    [ValidateSet('AzureDevOps','Local','AzureVM')]
    [Parameter(Mandatory=$false)]
    [string] $buildEnv = "AzureDevOps",

    [Parameter(Mandatory=$false)]
    [string] $containerName = $ENV:CONTAINERNAME,

    [Parameter(Mandatory=$false)]
    [string] $buildArtifactFolder = $ENV:BUILD_ARTIFACTSTAGINGDIRECTORY,

    [Parameter(Mandatory=$true)]
    [string] $appFolders,

    [switch] $skipVerification
)

Sort-AppFoldersByDependencies -appFolders $appFolders.Split(',') -baseFolder $buildProjectFolder -WarningAction SilentlyContinue | ForEach-Object {
    Write-Host "Publishing $_"
    Get-ChildItem -Path (Join-Path $buildArtifactFolder $_) -Filter "*.app" | ForEach-Object {
        Publish-NavContainerApp -containerName $containerName -appFile $_.FullName -skipVerification:$skipVerification -sync -install
    }
}
