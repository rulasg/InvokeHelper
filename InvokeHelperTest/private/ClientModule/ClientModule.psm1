<#
.SYNOPSIS
This code performs a specific task.

.DESCRIPTION
This code is responsible for [describe the purpose or functionality of the code].

.PARAMETER Parameter1
[Describe the purpose or usage of Parameter1].

.PARAMETER Parameter2
[Describe the purpose or usage of Parameter2].

.INPUTS
[Describe any input requirements or expected input types].

.OUTPUTS
[Describe the expected output or return value].

.EXAMPLE
Example usage of the code:

    PS> .\Script.ps1 -Parameter1 "Value1" -Parameter2 "Value2"

.NOTES
[Add any additional notes or information about the code].
#>

enum CmdKey {
    GetUser
    GetVersion
}

$CommandList =@{
    [CmdKey]::GetUser = 'gh api user'
    [CmdKey]::GetVersion = 'gh version'
}


<#
.SYNOPSIS
Will start a job with the given command.
#>
function Get-MockFunctionCall{
    [CmdletBinding()]
    param()

    # $command = $CommandList[[CmdKey]::GetUser)]
    $command = $CommandList.[CmdKey]::GetUser

    $result = Invoke-MyCommand -Command $command

    return $result
} Export-ModuleMember -Function Get-MockFunctionCall
