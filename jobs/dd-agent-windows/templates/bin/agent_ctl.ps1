# Start the Agent
Start-Process -NoNewWindow -FilePath "C:\var\vcap\packages\dd-agent-windows\Datadog Agent\bin\agent.exe" -ArgumentList " start -c \var\vcap\jobs\dd-agent-windows\config\datadog.yaml"
