function Build-ScriptBlock{
    [CmdletBinding()]
    [OutputType([ScriptBlock])]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command,
        [Parameter()][hashtable]$Parameters
    )
    process {

        if(Test-InvokeCommandAlias -Alias $Command){
            $cmd = Get-InvokeCommandAlias -Alias $Command
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