<#
.SYNOPSIS
Will start a job with the given command.

.PARAMETER Command
Command to run in the job.

.OUTPUTS
The Job started.
#>

function Start-MyJob{
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command,
        [Parameter(Position=1)][hashtable]$Parameters
    )
    process {

        $cmd = Build-Command -Command $Command -Parameters $Parameters

        $scriptBlock = New-ScriptBlock -Command $cmd

        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            $job = Start-Job -ScriptBlock $scriptBlock
        } else {
            Write-Information $scriptBlock
            $job = Start-Job -ScriptBlock {$null}
        }

        return $job
    }
} Export-ModuleMember -Function Start-MyJob

