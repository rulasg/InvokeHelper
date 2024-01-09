function InvokeHelperTest_InvokeCommandAlias_Get{

    Set-InvokeCommandAlias -Alias "commandAlias" -Command 'echo "this is a sample command"'
    Set-InvokeCommandAlias -Alias "commandAlias2" -Command 'echo "this is a sample command2"'

    $result = Get-InvokeCommandAliasList

    Assert-AreEqual -Expected 'echo "this is a sample command"' -Presented $result["commandAlias"].Command
    Assert-AreEqual -Expected 'echo "this is a sample command2"' -Presented $result["commandAlias2"].Command
}

function InvokeHelperTest_InvokeCommandAlias_Reset{
    
    Reset-InvokeCommandAlias

    $result = Get-InvokeCommandAliasList
    Assert-IsNull -Object $result
    
    Set-InvokeCommandAlias -Alias "commandAlias" -Command 'echo "this is a sample command"'
    Set-InvokeCommandAlias -Alias "commandAlias2" -Command 'echo "this is a sample command2"'

    $result = Get-InvokeCommandAliasList
    Assert-AreEqual -Expected 'echo "this is a sample command"' -Presented $result["commandAlias"].Command
    Assert-AreEqual -Expected 'echo "this is a sample command2"' -Presented $result["commandAlias2"].Command

    Reset-InvokeCommandAlias
    $result = Get-InvokeCommandAliasList
    Assert-IsNull -Object $result
}

function InvokeHelperTest_InvokeCommandAlias_Reset_WithTag{
    Reset-InvokeCommandAlias

    $result = Get-InvokeCommandAliasList
    Assert-IsNull -Object $result

    Set-InvokeCommandAlias -Alias "commandAlias11" -Command 'echo "this is a sample command11"' -Tag Mock1
    Set-InvokeCommandAlias -Alias "commandAlias21" -Command 'echo "this is a sample command21"' -Tag Mock2
    Set-InvokeCommandAlias -Alias "commandAlias12" -Command 'echo "this is a sample command12"' -Tag Mock1
    Set-InvokeCommandAlias -Alias "commandAlias22" -Command 'echo "this is a sample command22"' -Tag Mock2
    
    $result = Get-InvokeCommandAliasList

    Assert-Count -Expected 4 -Presented $result
    Assert-AreEqual -Expected 'echo "this is a sample command11"' -Presented $result["commandAlias11"].Command
    Assert-AreEqual -Expected 'echo "this is a sample command21"' -Presented $result["commandAlias21"].Command
    Assert-AreEqual -Expected 'echo "this is a sample command12"' -Presented $result["commandAlias12"].Command
    Assert-AreEqual -Expected 'echo "this is a sample command22"' -Presented $result["commandAlias22"].Command


    Reset-InvokeCommandAlias -Tag Mock1

    $result = Get-InvokeCommandAliasList

    Assert-Count -Expected 2 -Presented $result
    Assert-AreEqual -Expected 'echo "this is a sample command21"' -Presented $result["commandAlias21"].Command
    Assert-AreEqual -Expected 'echo "this is a sample command22"' -Presented $result["commandAlias22"].Command
}

function InvokeHelperTest_InvokeCommandAlias_Enable_Disable{

    Set-InvokeCommandAlias -Alias "commandAlias1" -Command "echo $text1" -Tag Mock1
    Set-InvokeCommandAlias -Alias "commandAlias2" -Command "echo $text2" -Tag Mock2
    Set-InvokeCommandAlias -Alias "commandAlias3" -Command "echo $text3" -Tag Mock1
    Set-InvokeCommandAlias -Alias "commandAlias4" -Command "echo $text4" -Tag Mock2

    Disable-InvokeCommandAlias -Tag Mock1

    $result = Get-InvokeCommandAliasList

    Assert-IsFalse -Condition $result.commandAlias1.Enabled
    Assert-IsFalse -Condition $result.commandAlias3.Enabled

    Assert-IsTrue -Condition $result.commandAlias2.Enabled
    Assert-IsTrue -Condition $result.commandAlias4.Enabled

    Enable-InvokeCommandAlias -Tag Mock1

    Assert-IsTrue -Condition $result.commandAlias1.Enabled
    Assert-IsTrue -Condition $result.commandAlias3.Enabled
    
    Assert-IsTrue -Condition $result.commandAlias2.Enabled
    Assert-IsTrue -Condition $result.commandAlias4.Enabled
}

function InvokeHelperTest_InvokeCommandAlias_Invoke_Enable_Disable{

    $text1 = "this is a sample command 1"
    $text2 = "this is a sample command 2"

    Set-InvokeCommandAlias -Alias "commandAlias1" -Command "echo $text1" -Tag Mock1
    Set-InvokeCommandAlias -Alias "commandAlias2" -Command "echo $text2" -Tag Mock2

    $result = Invoke-MyCommand -Command "commandAlias1"
    Assert-AreEqual -Expected $text1 -Presented $result

    $result = Invoke-MyCommand -Command "commandAlias2"
    Assert-AreEqual -Expected $text2 -Presented $result

    Disable-InvokeCommandAlias -Tag Mock1

    $hasthrow = $false
    try{
        $result = Invoke-MyCommand -Command "commandAlias1"
    } catch {
        $hasthrow = $true
    }
    Assert-IsTrue -Condition $hasthrow

    $result = Invoke-MyCommand -Command "commandAlias2"
    Assert-AreEqual -Expected $text2 -Presented $result

    Enable-InvokeCommandAlias -Tag Mock1

    $result = Invoke-MyCommand -Command "commandAlias1"
    Assert-AreEqual -Expected $text1 -Presented $result
}

function InvokeHelperTest_InvokeCommandAlias_Invoke_Mock_Disabled{

    $text1 = "this is a sample command 1"
    $text2 = "this is a sample command 2"
    $text1Mock = "this is a sample command 1 Mock"
    $text2Mock = "this is a sample command 2 Mock"

    Set-InvokeCommandAlias -Alias "commandAlias1" -Command "echo $text1" -Tag "myModule"
    Set-InvokeCommandAlias -Alias "commandAlias2" -Command "echo $text2" -Tag "myModule"
    Set-InvokeCommandAlias -Alias "commandAlias3" -Command "echo $text3" -Tag "myModule"

    Set-InvokeCommandAlias -Alias "echo $text1" -Command "echo $text1Mock" -Tag Mock1
    Set-InvokeCommandAlias -Alias "echo $text2" -Command "echo $text2Mock" -Tag Mock2

    # Disable all module commands
    Disable-InvokeCommandAlias -Tag "myModule"

    # Call module command with mock
    $result = Invoke-MyCommand -Command "commandAlias1"
    Assert-AreEqual -Expected $text1Mock -Presented $result

    # Call module command with mock
    $result = Invoke-MyCommand -Command "commandAlias2"
    Assert-AreEqual -Expected $text2Mock -Presented $result

    # Call module command with no mock
    $hasthrow = $false
    try{
        $result = Invoke-MyCommand -Command "commandAlias3"
    } catch {
        $hasthrow = $true
    }
    Assert-IsTrue -Condition $hasthrow

    # Disable a Mock tag
    Disable-InvokeCommandAlias -Tag Mock1

    # Call a module command with a disabled mock
    $hasthrow = $false
    try{
        $result = Invoke-MyCommand -Command "commandAlias1"
    } catch {
        $hasthrow = $true
    }
    Assert-IsTrue -Condition $hasthrow

    # enable a Mock tag
    Enable-InvokeCommandAlias -Tag Mock1

    # Call a module command with just enabled mock
    $result = Invoke-MyCommand -Command "commandAlias1"
    Assert-AreEqual -Expected $text1Mock -Presented $result
}