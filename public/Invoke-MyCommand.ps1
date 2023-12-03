<#
.SYNOPSIS
Execute the command

.PARAMETER Command
Command to be executed

.OUTPUTS
Return of the expression

.EXAMPLE
Invoke-MyCommand -Command 'gh api user'

#>

function Invoke-MyCommand {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Position=0)][string]$Command
    )

    if ($PSCmdlet.ShouldProcess("Target", $command)) {
        $scriptBlock = Build-ScriptBlock -Command $Command
        $result = Invoke-Command -ScriptBlock $scriptBlock
    } else {
        Write-Information $command
        $result = $null
    }

    return $result
} Export-ModuleMember -Function Invoke-MyCommand