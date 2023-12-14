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

    # Set the mock you want to use based on a Alias the function will use
    Set-InvokeCommandAlias -Alias 'Command to call to Mock' -Command $comand

    # Call the function with the Alias as normal
    $result = Invoke-MyCommandAsync -Command 'Command to call to Mock'

    Assert-AreEqual -Expected 'fakeName' -Presented $result.login
    Assert-AreEqual -Expected 6666666 -Presented $result.id
}

function InvokeHelperTest_MyCommandJsonAsync_Invoke{

    $comand = '@{login = "FakeName"; id="6666666"} | ConvertTo-Json'

    $result = Invoke-MyCommandJsonAsync -Command $comand

    Assert-AreEqual -Expected "FakeName" -Presented $result.login
    Assert-AreEqual -Expected 6666666 -Presented $result.id
}

function InvokeHelperTest_MyCommandJsonAsync_Invoke_Commands_WithParameters{
    $comands = @()
    $comands += '@{login = "{user}"; id="{id}"; task="Task1"} | ConvertTo-Json'
    $comands += '@{login = "{user}"; id="{id}"; task="Task2"} | ConvertTo-Json'
    $comands += '@{login = "{user}"; id="{id}"; task="Task3"} | ConvertTo-Json'
    $param = @{user = "FakeName"; id="6666666"}

    $result = Invoke-MyCommandJsonAsync -Commands $comands -Parameters $param

    $uniqueUser = $result | Select-Object -Property login -Unique
    Assert-Count -Expected 1 -Presented $uniqueUser
    Assert-AreEqual -Expected "FakeName" -Presented $uniqueUser.login

    $uniqueId = $result | Select-Object -Property id -Unique
    Assert-Count -Expected 1 -Presented $uniqueId
    Assert-AreEqual -Expected 6666666 -Presented $uniqueId.id

    $tasks = $result | Select-Object -ExpandProperty task -Unique
    Assert-Count -Expected 3 -Presented $tasks
    Assert-Contains -Expected "Task1" -Presented $tasks
    Assert-Contains -Expected "Task2" -Presented $tasks
    Assert-Contains -Expected "Task3" -Presented $tasks
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

function InvokeHelperTest_MyCommandAsync_Invoke_Multiple_StingArray_WithMock{
    $milliSeconds = 200
    $number = 5

    $commands = @()
    $commandPattern = 'Command with number {number}"'
    $comandMockPattern = 'Start-Sleep -Milliseconds {milliseconds} ; @{login = "FakeName"; id="{number}"}'
    $comandMockPattern = $comandMockPattern -replace '{milliseconds}', $milliSeconds

    $commands = @()

    # Mock all the calls to commands
    1..$number | ForEach-Object {

        $command = $commandPattern -replace '{number}', $_
        $commandMock = $comandMockPattern -replace '{number}', $_
        Set-InvokeCommandAlias -Alias $command -Command $commandMock

        $commands += $command
    }

    # Call asyn all commands in $commands
    $measure = Measure-Command {

        $result = Invoke-MyCommandAsync -Commands $commands

        Assert-Count -Expected $number -Presented $result
    }

    # Meausre that all the calls take less that
    "Used $measure.milliseconds milliseconds to run 5 jobs of $milliseconds milliseconds." | Write-Verbose
    Assert-IsTrue -Condition ($measure.milliseconds -lt ($number * $milliSeconds))

    1..$number | ForEach-Object {
        Assert-Contains  -Expected $_ -Presented $result.Id
    }
}