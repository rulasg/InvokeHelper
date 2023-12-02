function InvokeHelperTest_MyExpressionJson_Invoke{

    $global:test_json = '{"login": "rulasg","id": 6884408}'
    $comand = 'echo $global:test_json'

    $result = Invoke-MyExpressionJson -Command $comand

    Assert-AreEqual -Expected "rulasg" -Presented $result.login
    Assert-AreEqual -Expected 6884408 -Presented $result.id
}