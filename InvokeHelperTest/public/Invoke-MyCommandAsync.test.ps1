function InvokeHelperTest_MyCommandAsync_Invoke{

    $command = 'echo "Hello world"'
    $result = Invoke-MyCommandAsync -Command $command

    Assert-AreEqual  -Expected "Hello world" -Presented $result
}

function InvokeHelperTest_MyCommandAsync_Invoke_WhatIF{

    $command = "comand text"
    $result = Invoke-MyCommandAsync -Command $command -WhatIf @InfoParameters

    Assert-IsNull -Object $result
    Assert-Contains -Expected $command -Presented $infoVar
}

function InvokeHelperTest_MyCommandAsync_Invoke_WithMock {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '', Scope='Function')]
    param()

    $comand = '@{login = "FakeName"; id="6666666"}'

    # Set the mock you want to use based on a CommandKey the function will use
    Set-MockInvokeCommand -CommandKey 'Command to call to Mock' -Command $comand

    # Call the function with the CommandKey as normal
    $result = Invoke-MyCommandAsync -Command 'Command to call to Mock'

    Assert-AreEqual -Expected 'fakeName' -Presented $result.login
    Assert-AreEqual -Expected 6666666 -Presented $result.id
}

function InvokeHelperTest_MyCommandJsonAsync_Invoke{
    [CmdletBinding()]
    param()

    $comand = '@{login = "FakeName"; id="6666666"}'

    $result = Invoke-MyCommandAsync -Command $comand

    Assert-AreEqual -Expected "fakeName" -Presented $result.login
    Assert-AreEqual -Expected 6666666 -Presented $result.id
}

#### several calls

function InvokeHelperTest_MyCommandAsync_Invoke_Multiple_Pipped{

    $milliSeconds = 200
    $number = 5

    $commands = @()

    $command = 'echo "Hello world {number}"'

    1..$number | ForEach-Object {
        $commands += $command -replace '{number}', $_
    }

    $measure = Measure-Command {

        $result = $commands | Invoke-MyCommandAsync

        Assert-Count -Expected $number -Presented $result
    }

    "Used $measure.milliseconds milliseconds to run 5 jobs of $milliseconds milliseconds." | Write-Verbose
    Assert-IsTrue -Condition ($measure.milliseconds -lt ($number * $milliSeconds))

    1..$number | ForEach-Object {
        Assert-Contains  -Expected "Hello world $_" -Presented $result
    }

}

function InvokeHelperTest_MyCommandAsync_Invoke_Multiple_StingArray{

    $milliSeconds = 200
    $number = 5

    $commands = @()

    $command = 'echo "Hello world {number}"'

    1..$number | ForEach-Object {
        $commands += $command -replace '{number}', $_
    }

    $measure = Measure-Command {

        $result = Invoke-MyCommandAsync -Commands $commands

        Assert-Count -Expected $number -Presented $result
    }

    "Used $measure.milliseconds milliseconds to run 5 jobs of $milliseconds milliseconds." | Write-Verbose
    Assert-IsTrue -Condition ($measure.milliseconds -lt ($number * $milliSeconds))

    1..$number | ForEach-Object {
        Assert-Contains  -Expected "Hello world $_" -Presented $result
    }

}