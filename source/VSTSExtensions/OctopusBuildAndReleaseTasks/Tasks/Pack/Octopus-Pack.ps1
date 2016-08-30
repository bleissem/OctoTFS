﻿[CmdletBinding()]
param()

Trace-VstsEnteringInvocation $MyInvocation

try {

    . .\Octopus-VSTS.ps1

    $PackageId = Get-VstsInput -Name PackageId -Require
    $PackageFormat = Get-VstsInput -Name PackageFormat -Require
    $PackageVersion = Get-VstsInput -Name PackageVersion
    $OutputPath = Get-VstsInput -Name OutputPath
    $SourcePath = Get-VstsInput -Name SourcePath
    $NuGetAuthor = Get-VstsInput -Name NuGetAuthor
    $NuGetTitle = Get-VstsInput -Name NuGetTitle
    $NuGetDescription = Get-VstsInput -Name NuGetDescription
    $NuGetReleaseNotes = Get-VstsInput -Name NuGetReleaseNotes
    $NuGetReleaseNotesFile = Get-VstsInput -Name NuGetReleaseNotesFile
    $Overwrite = Get-VstsInput -Name Overwrite -AsBool
    $Include = Get-VstsInput -Name Include

    # Call Octo.exe
    $octoPath = Get-OctoExePath
    $Arguments = "pack --id=`"$PackageId`" --format=$PackageFormat --version=$PackageVersion --outFolder=`"$OutputPath`" --basePath=`"$SourcePath`" --author=`"$NugetAuthor`" --title=`"$NugetTitle`" --description=`"$NugetDescription`" --releaseNotes=`"$NuGetReleaseNotes`" --releaseNotesFile=`"$NugetReleaseNotesFile`" --overwrite=$Overwrite"
    if ($Include) {
       ForEach ($IncludePath in $Include.replace("`r", "").split("`n")) {
       $Arguments = $Arguments + " --include=`"$IncludePath`""
       }
    }

    Invoke-VstsTool -FileName $octoPath -Arguments $Arguments -RequireExitCodeZero

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}

