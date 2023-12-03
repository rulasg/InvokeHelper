function Build-ScriptBlock{
    [CmdletBinding()]
    [OutputType([ScriptBlock])]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command
    )
    process {

        if($InvokeCommands.ContainsKey($Command)){
            $cmd = $InvokeCommands[$Command]
        } else {
            $cmd = $Command
        }

        $ScriptBlock = [ScriptBlock]::Create($cmd)
        return $ScriptBlock
    }
}