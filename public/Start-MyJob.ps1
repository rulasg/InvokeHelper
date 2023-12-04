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
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command
    )
    process {

        $scriptBlock  = Build-ScriptBlock -Command $Command

        if ($PSCmdlet.ShouldProcess("Target", "Operation")) {
            $job = Start-Job -ScriptBlock $scriptBlock
        } else {
            Write-Information $scriptBlock
            $job = Start-Job -ScriptBlock {$null}
        }

        return $job
    }
} Export-ModuleMember -Function Start-MyJob

