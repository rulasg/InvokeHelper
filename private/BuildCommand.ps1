function Build-ScriptBlock{
    [CmdletBinding()]
    [OutputType([ScriptBlock])]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command
    )
    process {

        if(Test-MockInvokeCommand -Command $Command){
            $cmd = Get-MockInvokeCommand -Command $Command
        } else {
            $cmd = $Command
        }

        $ScriptBlock = [ScriptBlock]::Create($cmd)
        return $ScriptBlock
    }
}