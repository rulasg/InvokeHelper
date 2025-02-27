
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
                Enabled = $true
            }
        }
    }
} Export-ModuleMember -Function Set-InvokeCommandAlias

<#
.SYNOPSIS
Get the Command list active in the module
#>
function Get-InvokeCommandAliasList{
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter()][string]$Tag
    )

    if($script:InvokeCommandList -eq $null -or $script:InvokeCommandList.Count -eq 0){
        return $null
    }

    $ret = @{}

    if(-Not [string]::IsNullOrWhiteSpace($Tag)){
        $validKeys = $script:InvokeCommandList.Keys | Where-Object { $script:InvokeCommandList.$_.Tag -eq $Tag }
        $validKeys | ForEach-Object { $ret.$_ = $script:InvokeCommandList.$_ }
    } else {
        $ret = $script:InvokeCommandList
    }

    return $ret

} Export-ModuleMember -Function Get-InvokeCommandAliasList

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
        [Parameter(Mandatory,Position=0)][string]$Alias
    )

    return $InvokeCommandList[$Alias]
}

<#
.SYNOPSIS
Reset Command list
#>
function Reset-InvokeCommandAlias{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter()][string]$Tag
    )

    process {

        $newInvokeCommandList = @{}

        if(-Not [string]::IsNullOrWhiteSpace($Tag)){
            $validKeys = $script:InvokeCommandList.Keys | Where-Object { $script:InvokeCommandList.$_.Tag -ne $Tag }
            $validKeys | ForEach-Object { $newInvokeCommandList[$_] = $script:InvokeCommandList[$_] }
        }

        if ($PSCmdlet.ShouldProcess("CommandList", "Reset")) {
            $script:InvokeCommandList = $newInvokeCommandList
        }

        "$script:InvokeCommandList" | Write-Verbose

    }
} Export-ModuleMember -Function Reset-InvokeCommandAlias

# Initilize $InvokeCommandList
Reset-InvokeCommandAlias

<#
.SYNOPSIS
Disable a set of command alias by tag
#>
function Disable-InvokeCommandAlias{
    [CmdletBinding()]
    param(
        [Parameter()][string]$Tag
    )

    Set-InvokeCommandTagEnabled -Tag $Tag -Value $false

} Export-ModuleMember -Function Disable-InvokeCommandAlias

<#
.SYNOPSIS
Enable a set of command alias by tag
#>
function Enable-InvokeCommandAlias{
    [CmdletBinding()]
    param(
        [Parameter()][string]$Tag
    )

    Set-InvokeCommandTagEnabled -Tag $Tag -Value $true

} Export-ModuleMember -Function Enable-InvokeCommandAlias

function Set-InvokeCommandTagEnabled{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Tag,
        [Parameter(Mandatory)][bool]$Value
    )

    Foreach ($key in $InvokeCommandList.Keys) {
        $tag = $Tag.ToLower()
        $aliasTag = $InvokeCommandList[$key].Tag.ToLower()

        $sameTag = $tag -eq $aliasTag
        $alltags = $tag.ToLower() -eq "all" -or $tag -eq "*"

        if($sameTag -or $alltags){
            $InvokeCommandList[$key].Enabled = $Value
        }
    }
}