New-Item -Force "HKLM:Software\Datadog\Datadog Agent"
New-ItemProperty -Path "HKLM:Software\Datadog\Datadog Agent" -Name "InstallPath" -Value "\var\vcap\packages\dd-agent-windows\Datadog\"
New-ItemProperty -Path "HKLM:Software\Datadog\Datadog Agent" -Name "ConfigRoot" -Value "\var\vcap\jobs\dd-agent-windows\config\"
New-Item -Force -Path "\var\vcap\jobs\dd-agent-windows\config\" -Name "logs" -ItemType "directory"

Start-Process -NoNewWindow -Wait "\var\vcap\packages\dd-agent-windows\Datadog\bin\agent\install-cmd.exe" -ArgumentList "-bindir \var\vcap\packages\dd-agent-windows\Datadog\ -confdir \var\vcap\jobs\dd-agent-windows\config\"

icacls \var\vcap\packages\dd-agent-windows\Datadog\ /inheritance:e /grant "ddagentuser:(OI)(CI)(RX,WDAC)"
icacls \var\vcap\packages\dd-agent-windows\Datadog\ /inheritance:e /grant "ddagentuser:(OI)(CI)" /T

Start-Service datadogagent
