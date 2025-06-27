
# Invoke command use powershell calls to manage the dependencies
# if a string contains double quotes, it will fail as it will confuse the string content with parameter values
# so we need to escape the double quotes in the string to ensure the quotes that are part of the string value and not parameter boundaries

function ConvertTo-InvokeParameterString {
    param (
        [Parameter(ValueFromPipeline, Position = 0)][string]$InputString
    )

    process{

        if ([string]::IsNullOrEmpty($InputString)) {
            return $InputString
        }
        
        $OutputString = $InputString -replace '"', '""'
        return $OutputString
    }
} Export-ModuleMember -Function ConvertTo-InvokeParameterString
