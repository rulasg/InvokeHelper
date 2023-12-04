function InvokeHelperTest_MyCommand_Invoke{

    $command = 'echo "Hello world"'
    $result = Invoke-MyCommand -Command $command

    Assert-AreEqual  -Expected "Hello world" -Presented $result
}

function InvokeHelperTest_MyCommand_Invoke_WhatIF{

    $command = "comand text"
    $result = Invoke-MyCommand -Command $command -WhatIf @InfoParameters

    Assert-IsNull -Object $result
    Assert-Contains -Expected $command -Presented $infoVar
}

function InvokeHelperTest_Invoke_MyCommand_WithMock {
    [CmdletBinding()]
    param()

    # $global:test_json = '{"login": "fakeName","id": 6666666}'
    # $comand = 'echo $global:test_json'
    $comand = '@{login = "FakeName"; id="6666666"} | ConvertTo-Json'

    # Set the mock you want to use based on a CommandKey the function will use
    Set-MockInvokeCommand -CommandKey 'Command to call to Mock' -Command $comand

    # Call the function with the CommandKey as normal
    $result = Invoke-MyCommandJson -Command 'Command to call to Mock'

    Assert-AreEqual -Expected 'fakeName' -Presented $result.login
    Assert-AreEqual -Expected 6666666 -Presented $result.id

}

function InvokeHelperTest_MyCommandJson_Invoke{
    [CmdletBinding()]
    param()

    $comand = '@{login = "FakeName"; id="6666666"} | ConvertTo-Json'

    $result = Invoke-MyCommandJson -Command $comand

    Assert-AreEqual -Expected "fakeName" -Presented $result.login
    Assert-AreEqual -Expected 6666666 -Presented $result.id
}