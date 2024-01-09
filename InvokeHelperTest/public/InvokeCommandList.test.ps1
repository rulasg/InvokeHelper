function InvokeHelperTest_InvokeCommandAlias_Get{

    Set-InvokeCommandAlias -Alias "commandAlias" -Command 'echo "this is a sample command"'
    Set-InvokeCommandAlias -Alias "commandAlias2" -Command 'echo "this is a sample command2"'

    $result = Get-InvokeCommandAlias

    Assert-AreEqual -Expected 'echo "this is a sample command"' -Presented $result["commandAlias"].Command
    Assert-AreEqual -Expected 'echo "this is a sample command2"' -Presented $result["commandAlias2"].Command
}

function InvokeHelperTest_InvokeCommandAlias_Reset{
    
    Reset-InvokeCommandAlias

    $result = Get-InvokeCommandAlias
    Assert-IsNull -Object $result
    
    Set-InvokeCommandAlias -Alias "commandAlias" -Command 'echo "this is a sample command"'
    Set-InvokeCommandAlias -Alias "commandAlias2" -Command 'echo "this is a sample command2"'

    $result = Get-InvokeCommandAlias
    Assert-AreEqual -Expected 'echo "this is a sample command"' -Presented $result["commandAlias"].Command
    Assert-AreEqual -Expected 'echo "this is a sample command2"' -Presented $result["commandAlias2"].Command

    Reset-InvokeCommandAlias
    $result = Get-InvokeCommandAlias
    Assert-IsNull -Object $result
}

function InvokeHelperTest_InvokeCommandAlias_Reset_WithTag{
    Reset-InvokeCommandAlias

    $result = Get-InvokeCommandAlias
    Assert-IsNull -Object $result

    Set-InvokeCommandAlias -Alias "commandAlias11" -Command 'echo "this is a sample command11"' -Tag Mock1
    Set-InvokeCommandAlias -Alias "commandAlias21" -Command 'echo "this is a sample command21"' -Tag Mock2
    Set-InvokeCommandAlias -Alias "commandAlias12" -Command 'echo "this is a sample command12"' -Tag Mock1
    Set-InvokeCommandAlias -Alias "commandAlias22" -Command 'echo "this is a sample command22"' -Tag Mock2
    
    $result = Get-InvokeCommandAlias

    Assert-Count -Expected 4 -Presented $result
    Assert-AreEqual -Expected 'echo "this is a sample command11"' -Presented $result["commandAlias11"].Command
    Assert-AreEqual -Expected 'echo "this is a sample command21"' -Presented $result["commandAlias21"].Command
    Assert-AreEqual -Expected 'echo "this is a sample command12"' -Presented $result["commandAlias12"].Command
    Assert-AreEqual -Expected 'echo "this is a sample command22"' -Presented $result["commandAlias22"].Command


    Reset-InvokeCommandAlias -Tag Mock1

    $result = Get-InvokeCommandAlias

    Assert-Count -Expected 2 -Presented $result
    Assert-AreEqual -Expected 'echo "this is a sample command21"' -Presented $result["commandAlias21"].Command
    Assert-AreEqual -Expected 'echo "this is a sample command22"' -Presented $result["commandAlias22"].Command
}