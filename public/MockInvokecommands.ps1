
$script:MockInvokeCommands = @{}

<#
.SYNOPSIS
Set Command list with the key and command
#>
function Set-MockInvokeCommand{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$CommandKey,
        [Parameter(Mandatory,ValueFromPipeline,Position=1)][string]$Command
    )
    process {
        if ($PSCmdlet.ShouldProcess("CommandList", "Set $CommandKey = $Command")) {
            $MockInvokeCommands[$CommandKey] = $Command
        }
    }
} Export-ModuleMember -Function Set-MockInvokeCommand

function Test-MockInvokeCommand{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$CommandKey
    )
    process {
        return $MockInvokeCommands.ContainsKey($CommandKey)
    }
}

function Get-MockInvokeCommand{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$CommandKey
    )
    process {
        return $MockInvokeCommands[$CommandKey]
    }
}

<#
.SYNOPSIS
Reset Command list
#>
function Reset-MockInvokeCommand{
    [CmdletBinding(SupportsShouldProcess)]
    param()
    process {
        if ($PSCmdlet.ShouldProcess("CommandList", "Reset")) {
            $MockInvokeCommands = @{}
        }

        "$MockInvokeCommands" | Write-Verbose

    }
} Export-ModuleMember -Function Reset-MockInvokeCommand

# Initilize $MockInvokeCommands
Reset-MockInvokeCommand