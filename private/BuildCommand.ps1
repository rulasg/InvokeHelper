function Build-Command{
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command,
        [Parameter()][hashtable]$Parameters
    )
    process {
        # Check if command is an alias. If not will return the command.
        $cmd1 = Resolve-InvokeCommandAlias -Alias $Command

        # Replace parameters on command
        if($Parameters){
            foreach($key in $Parameters.Keys){
                $cmd1 = $cmd1.Replace("{"+$key+"}",$Parameters[$key])
            }
        }

        # Resolve again checking for full command mocks
        $cmd2 = Resolve-InvokeCommandAlias -Alias $cmd1

        if($cmd1 -ne $cmd2){
            # We have a command call mock
            # TODO: Allow while chards for mocking commands
            "We should check if we are in a sandbox mode" | Write-Verbose
        } else {
            # TODO: Confirm that we are not on a SandBox Mode
            "write a warning if we are not on a sandbox mode" | Write-Verbose
        }

        "Built Script Block: $cmd2" | Write-Verbose

        return $cmd2
    }
}

function New-ScriptBlock{
    [CmdletBinding()]
    [OutputType([ScriptBlock])]
    param(
        [Parameter(Mandatory,Position=0)][string]$Command
    )
    $ScriptBlock = [ScriptBlock]::Create($Command)

    return $ScriptBlock
}