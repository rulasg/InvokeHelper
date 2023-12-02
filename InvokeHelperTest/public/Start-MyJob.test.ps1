function InvokeHelperTest_JobInternal_Start{

    $job = Start-MyJob -Command "echo 'Hello World'"

    $w = Wait-Job -Job $job

    Assert-AreEqual -Expected $job.Name -Presented $w.Name

    $result = Receive-Job -Job $job

    Assert-AreEqual -Expected $job.State -Presented "Completed"

    Assert-AreEqual -Expected "Hello World" -Presented $result
}