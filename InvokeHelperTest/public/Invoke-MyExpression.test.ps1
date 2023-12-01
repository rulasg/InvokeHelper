function InvokeHelperTest_MyExpression_Invoke_WhatIF{

    $command = "comand text"
    $result = Invoke-MyExpression -Command $command -WhatIf @InfoParameters

    Assert-IsNull -Object $result
    Assert-Contains -Expected $command -Presented $infoVar
}