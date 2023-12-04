function InvokeHelperTest_MyCommand_Invoke_WhatIF{

    $command = "comand text"
    $result = Invoke-MyCommand -Command $command -WhatIf @InfoParameters

    Assert-IsNull -Object $result
    Assert-Contains -Expected $command -Presented $infoVar
}

function InvkeHelperTest_Invoke_MyComandWithKey {

    Set-MockInvokeCommand -CommandKey GhGetUser -Command 'gh api user'

    $result = Invoke-MyCommandJson -Command 'GhGetUser'

    Assert-AreEqual -Expected 'rulasg' -Presented $result.login

}

function InvokeHelperTest_MyCommandJson_Invoke{
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '', Scope='Function')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Scope='Function')]
    param()

    $global:test_json = '{"login": "rulasg","id": 6884408}'
    $comand = 'echo $global:test_json'

    $result = Invoke-MyCommandJson -Command $comand

    Assert-AreEqual -Expected "rulasg" -Presented $result.login
    Assert-AreEqual -Expected 6884408 -Presented $result.id
}