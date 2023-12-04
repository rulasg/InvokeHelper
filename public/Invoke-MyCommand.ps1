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
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command
    )

    process{

        $scriptBlock = Build-ScriptBlock -Command $Command

        if ($PSCmdlet.ShouldProcess("Target", $command)) {

            $result = Invoke-Command -ScriptBlock $scriptBlock

        } else {
            Write-Information $scriptBlock
            $result = $null
        }

        return $result
    }
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