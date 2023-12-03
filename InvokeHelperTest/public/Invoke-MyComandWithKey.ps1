function InvkeHelperTest_Invoke_MyComandWithKey {

    Set-InvokeCommand -CommandKey GhGetUser -Command 'gh api user'

    $result = Invoke-MyCommandJson -Command 'GhGetUser'

    Assert-AreEqual -Expected 'rulasg' -Presented $result.login

}