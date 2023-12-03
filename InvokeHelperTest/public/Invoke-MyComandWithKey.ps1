function InvkeHelperTest_Invoke-MyComandWithKey {
    
    Set-InvokeCommand -CommandKey GhGetUser -Command 'gh api user'

    $result = Invoke-MyCommandJson -Command 'GhGetUser'

    Assert-AreEqual -Expected 'rulasg' -Presented $result.login
    
}