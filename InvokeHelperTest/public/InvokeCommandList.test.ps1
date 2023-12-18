function InvokeHelperTest_InvokeCommandAlias_Get{

    Set-InvokeCommandAlias -Alias "commandAlias" -Command 'echo "this is a sample command"'
    Set-InvokeCommandAlias -Alias "commandAlias2" -Command 'echo "this is a sample command2"'

    $result = Get-InvokeCommandAlias

    Assert-AreEqual -Expected 'echo "this is a sample command"' -Presented $result["commandAlias"]
    Assert-AreEqual -Expected 'echo "this is a sample command2"' -Presented $result["commandAlias2"]
}

function InvokeHelperTest_InvokeCommandAlias_Reset{

    Reset-InvokeCommandAlias

    $result = Get-InvokeCommandAlias
    Assert-IsNull -Object $result

    Set-InvokeCommandAlias -Alias "commandAlias" -Command 'echo "this is a sample command"'
    Set-InvokeCommandAlias -Alias "commandAlias2" -Command 'echo "this is a sample command2"'

    $result = Get-InvokeCommandAlias
    Assert-AreEqual -Expected 'echo "this is a sample command"' -Presented $result["commandAlias"]
    Assert-AreEqual -Expected 'echo "this is a sample command2"' -Presented $result["commandAlias2"]

    Reset-InvokeCommandAlias
    $result = Get-InvokeCommandAlias
    Assert-IsNull -Object $result
}