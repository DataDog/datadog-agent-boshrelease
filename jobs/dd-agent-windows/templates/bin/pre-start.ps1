# Move templated config file
Copy-Item -Path "\var\vcap\jobs\dd-agent-windows\config\datadog.yaml" -Destination "\var\vcap\packages\dd-agent-windows\CommonAppData\datadog.yaml"

# Setup proper registry fields
New-Item "hklm:Software/Datadog/datadog agent" -Force
Set-ItemProperty -Path "hklm:Software/DataDog/datadog agent/" -Name "InstallPath" -Value "\var\vcap\packages\dd-agent-windows\Datadog\"
Set-ItemProperty -Path "hklm:Software/DataDog/datadog agent/" -Name "ConfigRoot" -Value "\var\vcap\packages\dd-agent-windows\CommonAppData\"

# Install the Agent service
Start-Process -NoNewWindow -Wait sc.exe -ArgumentList "create datadogagent obj= `"NT AUTHORITY\Local Service`" password= `"`" binPath= \var\vcap\packages\dd-agent-windows\Datadog\bin\agent.exe"

# Need to manually create the Process/Trace agent services
Start-Process -NoNewWindow -Wait sc.exe -ArgumentList "create datadog-trace-agent obj= `"NT AUTHORITY\Local Service`" password= `"`" binPath= \var\vcap\packages\dd-agent-windows\Datadog\bin\agent\trace-agent.exe depend= `"datadogagent`""
Start-Process -NoNewWindow -Wait sc.exe -ArgumentList "create datadog-process-agent obj= `"NT AUTHORITY\Local Service`" password= `"`" binPath= \var\vcap\packages\dd-agent-windows\Datadog\bin\agent\process-agent.exe depend= `"datadogagent`""

Start-Process -NoNewWindow -Wait "\var\vcap\packages\dd-agent-windows\Datadog\bin\agent.exe" -ArgumentList "start-service"
