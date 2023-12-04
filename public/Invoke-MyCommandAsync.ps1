<#
.SYNOPSIS
Execute a set of commands async

.DESCRIPTION
Will wiat for all the jobs to finish and return the results

#>
function Invoke-MyCommandAsync {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(ValueFromPipeline,Position=0)][string]$Command,
        [Parameter()][string[]]$Commands
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

            $scriptBlock  = Build-ScriptBlock -Command $_

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