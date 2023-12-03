function InvokeHelperTest_MockFunctionCall{
    $clientModulePath = $PSScriptRoot | Split-Path -Parent | Join-Path -ChildPath private -AdditionalChildPath ClientModule
    Import-Module -name $clientModulePath -Force

    Set-InvokeCommand -CommandKey 'gh api user' -Command ' echo "Hello World" '

    $result = Get-MockFunctionCall

    Assert-AreEqual -Expected "Hello World" -Presented $result
}

function InvokeHelperTest_MockFunctionCallAsync{
    $clientModulePath = $PSScriptRoot | Split-Path -Parent | Join-Path -ChildPath private -AdditionalChildPath ClientModule
    Import-Module -name $clientModulePath -Force

    Set-InvokeCommand -CommandKey 'gh api user' -Command ' echo "Hello World" '

    $Job = Get-MockFunctionCallAsync

    $job = Wait-Job -Job $Job

    $result = Receive-Job -Job $Job

    Assert-AreEqual -Expected "Hello World" -Presented $result
}