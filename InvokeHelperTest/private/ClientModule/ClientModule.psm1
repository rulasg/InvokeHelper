
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
Will invoke a command
#>
function Get-FunctionCall{
    [CmdletBinding()]
    param()

    # $command = $CommandList[[CmdKey]::GetUser)]
    $command = $CommandList.[CmdKey]::GetUser

    $result = Invoke-MyCommand -Command $command

    return $result
} Export-ModuleMember -Function Get-FunctionCall

<#
.SYNOPSIS
Will start a job with the given command.
#>
function Get-FunctionCallAsync{
    [CmdletBinding()]
    param()

    # $command = $CommandList[[CmdKey]::GetUser)]
    $command = $CommandList.[CmdKey]::GetUser

    $result = Invoke-MyCommandAsync -Command $command

    return $result
} Export-ModuleMember -Function Get-FunctionCallAsync
