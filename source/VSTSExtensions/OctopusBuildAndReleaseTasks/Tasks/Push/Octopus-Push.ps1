﻿[CmdletBinding()]
param()

Trace-VstsEnteringInvocation $MyInvocation

try {

    . .\Octopus-VSTS.ps1

    $ConnectedServiceName = Get-VstsInput -Name ConnectedServiceName -Require
    $Packages = Get-VstsInput -Name Package -Require
    $AdditionalArguments = Get-VstsInput -Name AdditionalArguments
    $Replace = Get-VstsInput -Name Replace -AsBool

    $connectedServiceDetails = Get-VstsEndpoint -Name "$ConnectedServiceName" -Require
    $credentialArgs = Get-OctoCredentialArgs($connectedServiceDetails)
    $octopusUrl = $connectedServiceDetails.Url

    # Call Octo.exe
    $octoPath = Get-OctoExePath
    $Arguments = "push --server=$octopusUrl $credentialArgs $AdditionalArguments"

    ForEach($Package in ($Packages.Split("`r`n|`r|`n").Trim())) {
        if (-not [string]::IsNullOrEmpty($Package)) {

            foreach ($file in (Get-Item -Path $Package)){
                $Arguments = $Arguments + " --package=`"$file`""
            }
        }
    }

    if ($Replace) {
        $Arguments = $Arguments + " --replace-existing"
    }

    Invoke-VstsTool -FileName $octoPath -Arguments $Arguments -RequireExitCodeZero

} finally {
    Trace-VstsLeavingInvocation $MyInvocation
}
