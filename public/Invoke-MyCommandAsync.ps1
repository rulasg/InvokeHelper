<#

<#
.SYNOPSIS
Execute a set of commands async and return the results as they are available
#>
function Invoke-MyCommandAsync {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ParameterSetName = "Single",ValueFromPipeline,Position=0)][string]$Command,
        [Parameter(Mandatory,ParameterSetName = "Multiple")][string[]]$Commands,
        [Parameter(ParameterSetName = "Single",Position=1)]
        [Parameter(ParameterSetName = "Multiple",Position=1)]
        [hashtable]$Parameters
    )

    begin{
        $jobs = @()
        $cmds = $Commands ?? @()
    }

    process{
        if(-not [string]::IsNullOrWhiteSpace($Command)){
            $cmds += $Command
        }
    }

    end{

        $cmds | ForEach-Object {

            $cmd = Build-Command -Command $_ -Parameters $Parameters

            $scriptBlock = New-ScriptBlock -Command $cmd

            if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
                $job = Start-Job -ScriptBlock $scriptBlock
            } else {
                Write-Information $scriptBlock
                $job = Start-Job -ScriptBlock {$null}
            }

            $jobs += $job
        }

        $result = $jobs | Wait-Job | Receive-Job

        return $result
    }

} Export-ModuleMember -Function Invoke-MyCommandAsync

<#
.SYNOPSIS
    Execute a set of commands async and return the results as a PSCustomObject serialized from Json command output
#>
function Invoke-MyCommandJsonAsync {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(ParameterSetName = "Single",ValueFromPipeline)][string]$Command,
        [Parameter(ParameterSetName = "Multiple")][string[]]$Commands,
        [Parameter()][hashtable]$Parameters
    )
    begin{
        $cmds = $Commands ?? @()
    }

    process{
        if(-not [string]::IsNullOrWhiteSpace($Command)){
            $cmds += $Command
        }
    }

    end {

        $resultJson = Invoke-MyCommandAsync -Parameters $Parameters -Commands $cmds

        $result = $resultJson | ConvertFrom-Json

        return $result
    }

}Export-ModuleMember -Function Invoke-MyCommandJsonAsync