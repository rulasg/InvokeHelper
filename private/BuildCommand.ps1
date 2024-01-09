# function Build-Command{
#     [CmdletBinding()]
#     [OutputType([string])]
#     param(
#         [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command,
#         [Parameter()][hashtable]$Parameters
#     )
#     process {
#         # Check if command is an alias. If not will return the command.
#         $cmd1 = Resolve-InvokeCommandAlias -Alias $Command

#         # Replace parameters on command
#         $cmd1 = Update-CommandWithParameter -Command $cmd1 -Parameters $Parameters

#         # Resolve again checking for full command mocks
#         $cmd2 = Resolve-InvokeCommandAlias -Alias $cmd1

#         if($cmd1 -ne $cmd2){
#             # We have a command call mock
#             # TODO: Allow while chards for mocking commands
#             "We should check if we are in a sandbox mode" | Write-Verbose
#         } else {
#             # TODO: Confirm that we are not on a SandBox Mode
#             "write a warning if we are not on a sandbox mode" | Write-Verbose
#         }

#         "Built Script Block: $cmd2" | Write-Verbose

#         return $cmd2
#     }
# }

function Build-Command{
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command,
        [Parameter()][hashtable]$Parameters
    )
    process {
        # Check if command is an alias. If not will return the command after updating for parameters
        if(-Not (Test-InvokeCommandAlias -Alias $Command)){
            $cmd = Update-CommandWithParameter -Command $Command -Parameters $Parameters
            return $cmd
        }

        # Find the command for this alias
        $alias = Find-InvokeCommandAlias -Alias $Command

        # Build the command with parameter
        $cmd = Update-CommandWithParameter -Command $alias.Command -Parameters $Parameters

        # Recurse to check for mocks
        $mock = Find-InvokeCommandAlias -Alias $cmd
        if($mock){
            # We have a mock command
            $cmd = $mock.Command
            $alias = $mock
        }

        # Check if alias is disabled
        if(! $alias.Enabled){
            throw ("Alias command is disabled: $alias.Alias")
         }

         return $cmd
    }
}

function Update-CommandWithParameter{
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command,
        [Parameter()][hashtable]$Parameters
    )
    process {
        # Replace parameters on command
        if($Parameters){
            foreach($key in $Parameters.Keys){
                $Command = $Command.Replace("{"+$key+"}",$Parameters[$key])
            }
        }

        return $Command
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