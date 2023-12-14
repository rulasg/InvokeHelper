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
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command,
        [Parameter(Position=1)][hashtable]$Parameters
    )

    process{

        $scriptBlock = Build-ScriptBlock -Command $Command -Parameters $Parameters

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
    Execute a set of commands and return the results as a PSCustomObject serialized from Json command output

.EXAMPLE
    Invoke-MyCommandJson -Command 'gh api user'
#>
function Invoke-MyCommandJson {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Scope='Function')]
    # False positive. We need -WhatIf to call later Invoke-MyCommand with this preferences
    param(
        [Parameter(Mandatory,Position=0)][string]$Command,
        [Parameter(Position=1)][hashtable]$Parameters
    )

   $resultJson = Invoke-MyCommand -Command $Command -Parameters $Parameters

   $result = $resultJson | ConvertFrom-Json

    return $result
} Export-ModuleMember -Function Invoke-MyCommandJson