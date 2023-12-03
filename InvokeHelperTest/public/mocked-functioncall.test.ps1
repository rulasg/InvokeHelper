function InvokeHelperTest_MockFunctionCall{
    $clientModulePath = $PSScriptRoot | Split-Path -Parent | Join-Path -ChildPath private -AdditionalChildPath ClientModule
    Import-Module -name $clientModulePath -Force

    Set-InvokeCommand -CommandKey 'gh api user' -Command ' echo "Hello World" '

    $result = Get-MockFunctionCall

    Assert-AreEqual -Expected "Hello World" -Presented $result
}