function Build-ScriptBlock{
    [CmdletBinding()]
    [OutputType([ScriptBlock])]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command
    )
    process {

        if(Test-InvokeCommand -Command $Command){
            $cmd = Get-InvokeCommand -Command $Command
        } else {
            $cmd = $Command
        }

        $ScriptBlock = [ScriptBlock]::Create($cmd)
        return $ScriptBlock
    }
}