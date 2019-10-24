Start-Process -NoNewWindow -Wait "\var\vcap\packages\dd-agent-windows\Datadog\bin\agent.exe" -ArgumentList "stopservice"
echo 0; exit 0
