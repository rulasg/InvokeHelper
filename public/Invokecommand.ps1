function Set-InvokeCommand{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$CommandKey,
        [Parameter(Mandatory,ValueFromPipeline,Position=1)][string]$Command
    )
    process {
        $InvokeCommands[$CommandKey] = $Command
    }
} Export-ModuleMember -Function Set-InvokeCommand

function Reset-InvokeCommand{
    [CmdletBinding()]
    param()
    process {
        $script:InvokeCommands=@{}
    }
} Export-ModuleMember -Function Reset-InvokeCommand

# Reset Invoke Commands
Reset-InvokeCommand