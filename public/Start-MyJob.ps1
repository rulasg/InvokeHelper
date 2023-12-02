<#
.SYNOPSIS
Will start a job with the given command.

.PARAMETER Command
Command to run in the job.

.OUTPUTS
The Job started.
#>

function Start-MyJob{
    [CmdletBinding()]
    param(
        # ScriptBlock
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command
    )
    process {

        $ScriptBlock = [ScriptBlock]::Create($Command)

        $job = Start-Job -ScriptBlock $ScriptBlock

        return $job
    }

} Export-ModuleMember -Function Start-MyJob

