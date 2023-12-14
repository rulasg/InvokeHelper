
$script:InvokeCommandList = @{}

<#
.SYNOPSIS
Set Command list with the key and command
#>
function Set-InvokeCommandAlias{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Alias,
        [Parameter(Mandatory,ValueFromPipeline,Position=1)][string]$Command
    )
    process {
        if ($PSCmdlet.ShouldProcess("CommandList", "Set $Alias = $Command")) {
            $InvokeCommandList[$Alias] = $Command
        }
    }
} Export-ModuleMember -Function Set-InvokeCommandAlias

function Test-InvokeCommandAlias{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Alias
    )
    process {
        return $InvokeCommandList.ContainsKey($Alias)
    }
}

function Get-InvokeCommandAlias{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Alias
    )
    process {
        return $InvokeCommandList[$Alias]
    }
}

<#
.SYNOPSIS
Reset Command list
#>
function Reset-InvokeCommandAlias{
    [CmdletBinding(SupportsShouldProcess)]
    param()
    process {
        if ($PSCmdlet.ShouldProcess("CommandList", "Reset")) {
            $InvokeCommandList = @{}
        }

        "$InvokeCommandList" | Write-Verbose

    }
} Export-ModuleMember -Function Reset-InvokeCommandAlias

# Initilize $InvokeCommandList
Reset-InvokeCommandAlias