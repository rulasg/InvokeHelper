function Build-ScriptBlock{
    [CmdletBinding()]
    [OutputType([ScriptBlock])]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command,
        [Parameter()][hashtable]$Parameters
    )
    process {

        if(Test-MockInvokeCommand -Command $Command){
            $cmd = Get-MockInvokeCommand -Command $Command
        } else {
            $cmd = $Command
        }

        # Replace parameters on command
        if($Parameters){
            foreach($key in $Parameters.Keys){
                $cmd = $cmd.Replace("{"+$key+"}",$Parameters[$key])
            }
        }

        $ScriptBlock = [ScriptBlock]::Create($cmd)

        return $ScriptBlock
    }
}