function Build-ScriptBlock{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,ValueFromPipeline,Position=0)][string]$Command
    )
    process {




        $ScriptBlock = [ScriptBlock]::Create($Command)
        return $ScriptBlock
    }
}