
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
