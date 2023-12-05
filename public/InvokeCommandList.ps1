
$script:InvokeCommandList = @{}

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
            $InvokeCommandList[$CommandKey] = $Command
        }
    }
} Export-ModuleMember -Function Set-InvokeCommand

function Test-InvokeCommand{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$CommandKey
    )
    process {
        return $InvokeCommandList.ContainsKey($CommandKey)
    }
}

function Get-InvokeCommand{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$CommandKey
    )
    process {
        return $InvokeCommandList[$CommandKey]
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
            $InvokeCommandList = @{}
        }

        "$InvokeCommandList" | Write-Verbose

    }
} Export-ModuleMember -Function Reset-InvokeCommand

# Initilize $InvokeCommandList
Reset-InvokeCommand