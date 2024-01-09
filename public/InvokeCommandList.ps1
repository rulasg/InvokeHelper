
$script:InvokeCommandList = @{}

<#
.SYNOPSIS
Set Command list with the key and command
#>
function Set-InvokeCommandAlias{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Alias,
        [Parameter(Mandatory,ValueFromPipeline,Position=1)][string]$Command,
        [Parameter(Position=2)][string]$Tag
    )
    process {
        if ($PSCmdlet.ShouldProcess("CommandList", "Set $Alias = $Command")) {
            $InvokeCommandList[$Alias] = [PSCustomObject]@{
                Alias = $Alias
                Command = $Command
                Tag = $Tag
            }
        }
    }
} Export-ModuleMember -Function Set-InvokeCommandAlias

<#
.SYNOPSIS
Get the Command list active in the module
#>
function Get-InvokeCommandAlias{
    [CmdletBinding()]
    [OutputType([hashtable])]
    param()

    if($script:InvokeCommandList -eq $null -or $script:InvokeCommandList.Count -eq 0){
        return $null
    } else {
        return $script:InvokeCommandList
    }

} Export-ModuleMember -Function Get-InvokeCommandAlias

function Test-InvokeCommandAlias{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Alias
    )
    process {
        return $InvokeCommandList.ContainsKey($Alias)
    }
}

function Resolve-InvokeCommandAlias{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Alias
    )
    process {
        if(Test-InvokeCommandAlias -Alias $Alias){
            $cmd = $InvokeCommandList[$Alias].Command
        } else {
            $cmd = $Alias
        }

        return $cmd
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
            $script:InvokeCommandList = @{}
        }

        "$script:InvokeCommandList" | Write-Verbose

    }
} Export-ModuleMember -Function Reset-InvokeCommandAlias

# Initilize $InvokeCommandList
Reset-InvokeCommandAlias