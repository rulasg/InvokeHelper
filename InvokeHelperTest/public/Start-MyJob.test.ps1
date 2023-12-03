function InvokeHelperTest_JobInternal_Start{

    $job = Start-MyJob -Command "echo 'Hello World'"

    $waited = Wait-Job -Job $job

    Assert-AreEqual -Expected $job.Name -Presented $waited.Name

    $result = Receive-Job -Job $job

    Assert-AreEqual -Expected $job.State -Presented "Completed"

    Assert-AreEqual -Expected "Hello World" -Presented $result
}

function InvokeHelperTest_JobInternal_Start_WhatIf{
    $jobs = @()
    $jobs += Start-MyJob -Command "command to be called1" -WhatIf @InfoParameters
    Assert-Contains -Expected "command to be called1" -Presented $infoVar

    $jobs += Start-MyJob -Command "command to be called2" -WhatIf @InfoParameters
    Assert-Contains -Expected "command to be called2" -Presented $infoVar

    $waited = Wait-Job -Job $jobs

    $result = Receive-Job -Job $waited

    Assert-Count -Expected 2 -Presented $result
    Assert-IsNull -Object $result[0]
    Assert-IsNull -Object $result[1]
}

function InvokeHelperTest_JobInternal_Start_MultiCall{

    $milliSeconds = 200
    $number = 5

    $measure = Measure-Command {
        $jobs = @()
        1..$number | ForEach-Object {
            $jobs += Start-MyJob -Command "Start-Sleep -Milliseconds $milliSeconds"
        }

        $result = Wait-Job -Job $jobs
        Assert-Count -Expected $number -Presented $result
    }

    "Used $measure.milliseconds milliseconds to run 5 jobs of $milliseconds milliseconds." | Write-Verbose
    Assert-IsTrue -Condition ($measure.milliseconds -lt ($number * $milliSeconds))

}