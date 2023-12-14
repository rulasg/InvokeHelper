# This Test will call a function on a module that calls Invoke-MyCommand with a command
# We will mock that command to return the desired test result

function InvokeHelperTest_FunctionCall{
    # Load de module
    $clientModulePath = $PSScriptRoot | Split-Path -Parent | Join-Path -ChildPath private -AdditionalChildPath ClientModule
    Import-Module -name $clientModulePath -Force

    # Set the mock to a valid command
    Set-InvokeCommandAlias -Alias 'gh api user' -Command ' echo "Hello World" '

    # Call the module funtion
    $result = Get-FunctionCall

    # Assert to the mock result
    Assert-AreEqual -Expected "Hello World" -Presented $result
}

function InvokeHelperTest_FunctionCallAsync{
    $clientModulePath = $PSScriptRoot | Split-Path -Parent | Join-Path -ChildPath private -AdditionalChildPath ClientModule
    Import-Module -name $clientModulePath -Force

    Set-InvokeCommandAlias -Alias 'gh api user' -Command ' echo "Hello World" '

    $result =  Get-FunctionCallAsync

    Assert-AreEqual -Expected "Hello World" -Presented $result
}