<#
.SYNOPSIS
Execute the command

.DESCRIPTION


.PARAMETER Command
Expression to be executed

.OUTPUTS
Return of the expression

.EXAMPLE
Invoke-MyExpression -Command 'gh api user'

#>

function Invoke-MyExpression {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '', Scope='Function')]
    param(
        [Parameter(Position=0)][string]$Command
    )

    if ($PSCmdlet.ShouldProcess("Target", $command)) {
        $result = Invoke-Expression $Command | ConvertFrom-Json
    } else {
        Write-Information $command
        $result = $null
    }

    return $result
} Export-ModuleMember -Function Invoke-MyExpression