# This Test will call a function on a module that calls Invoke-MyCommand with a command
# We will mock that command to return the desired test result

function InvokeHelperTest_MockFunctionCall{
    # Load de module
    $clientModulePath = $PSScriptRoot | Split-Path -Parent | Join-Path -ChildPath private -AdditionalChildPath ClientModule
    Import-Module -name $clientModulePath -Force

    # Set the mock to a valid command
    Set-MockInvokeCommand -CommandKey 'gh api user' -Command ' echo "Hello World" '

    # Call the module funtion
    $result = Get-MockFunctionCall

    # Assert to the mock result
    Assert-AreEqual -Expected "Hello World" -Presented $result
}

function InvokeHelperTest_MockFunctionCallAsync{
    $clientModulePath = $PSScriptRoot | Split-Path -Parent | Join-Path -ChildPath private -AdditionalChildPath ClientModule
    Import-Module -name $clientModulePath -Force

    Set-MockInvokeCommand -CommandKey 'gh api user' -Command ' echo "Hello World" '

    $Job = Get-MockFunctionCallAsync

    $job = Wait-Job -Job $Job

    $result = Receive-Job -Job $Job

    Assert-AreEqual -Expected "Hello World" -Presented $result
}