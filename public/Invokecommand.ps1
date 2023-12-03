
$script:InvokeCommands = @{}

<#
.SYNOPSIS
Set Command list with the key and command
#>
function Set-InvokeCommand{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$CommandKey,
        [Parameter(Mandatory,ValueFromPipeline,Position=1)][string]$Command
    )
    process {
        if ($PSCmdlet.ShouldProcess("CommandList", "Set $CommandKey = $Command")) {
            $InvokeCommands[$CommandKey] = $Command
        }
    }
} Export-ModuleMember -Function Set-InvokeCommand

function Test-InvokeCommand{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$CommandKey
    )
    process {
        return $InvokeCommands.ContainsKey($CommandKey)
    }
}

function Get-InvokeCommand{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$CommandKey
    )
    process {
        return $InvokeCommands[$CommandKey]
    }
}

<#
.SYNOPSIS
Reset Command list
#>
function Reset-InvokeCommand{
    [CmdletBinding(SupportsShouldProcess)]
    param()
    process {
        if ($PSCmdlet.ShouldProcess("CommandList", "Reset")) {
            $InvokeCommands = @{}
        }

        "$InvokeCommands" | Write-Verbose

    }
} Export-ModuleMember -Function Reset-InvokeCommand

# Reset Invoke Commands
Reset-InvokeCommand