<#
.SYNOPSIS
Execute the command

.DESCRIPTION
The command will generate a Json that the fun will serialize to a PSObject

.PARAMETER Command
Expression to be executed. This expresion will generate a Json

.OUTPUTS
Return of the expression

.EXAMPLE
Invoke-MyExpressionJson -Command 'gh api user'

#>

function Invoke-MyExpressionJson {
    [CmdletBinding(SupportsShouldProcess)]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSShouldProcess', '', Scope='Function')]
    # False positive. We need -WhatIf to call later Invoke-MyExpression with this preferences
    param(
        [Parameter(Position=0)][string]$Command
    )

   $resultJson = Invoke-MyExpression -Command $Command

   $result = $resultJson | ConvertFrom-Json

    return $result
} Export-ModuleMember -Function Invoke-MyExpressionJson