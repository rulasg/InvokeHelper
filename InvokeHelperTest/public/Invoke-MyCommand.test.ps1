function InvokeHelperTest_MyCommand_Invoke_WhatIF{

    $command = "comand text"
    $result = Invoke-MyCommand -Command $command -WhatIf @InfoParameters

    Assert-IsNull -Object $result
    Assert-Contains -Expected $command -Presented $infoVar
}