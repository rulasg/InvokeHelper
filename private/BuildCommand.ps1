function Build-ScriptBlock{
    [CmdletBinding()]
    [OutputType([ScriptBlock])]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command,
        [Parameter()][hashtable]$Parameters
    )
    process {
        # Check if command is an alias. If not will return the command.
        $cmd = Resolve-InvokeCommandAlias -Alias $Command

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

