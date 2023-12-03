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

<#
.SYNOPSIS
Execute the command

.DESCRIPTION
The command will generate a Json that the fun will serialize to a PSObject

.PARAMETER Command
Expression to be executed. This expresion will generate a Json

.OUTPUTS
Return of the expression

.EXAMPLE
Invoke-MyCommandJson -Command 'gh api user'
#>
function Invoke-MyCommandJson {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Scope='Function')]
    # False positive. We need -WhatIf to call later Invoke-MyCommand with this preferences
    param(
        [Parameter(Position=0)][string]$Command
    )

   $resultJson = Invoke-MyCommand -Command $Command

   $result = $resultJson | ConvertFrom-Json

    return $result
} Export-ModuleMember -Function Invoke-MyCommandJson