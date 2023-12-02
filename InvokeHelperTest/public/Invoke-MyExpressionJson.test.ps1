function InvokeHelperTest_MyExpressionJson_Invoke{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Scope='Function')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Scope='Function')]
    param()

    $global:test_json = '{"login": "rulasg","id": 6884408}'
    $comand = 'echo $global:test_json'

    $result = Invoke-MyExpressionJson -Command $comand

    Assert-AreEqual -Expected "rulasg" -Presented $result.login
    Assert-AreEqual -Expected 6884408 -Presented $result.id
}