# Overwrite the registry keys for the Agent if there are previous installs
New-Item -Force "HKLM:Software\Datadog\Datadog Agent"
New-ItemProperty -Force -Path "HKLM:Software\Datadog\Datadog Agent" -Name "InstallPath" -Value "\var\vcap\packages\dd-agent-windows\Datadog\"
New-ItemProperty -Force -Path "HKLM:Software\Datadog\Datadog Agent" -Name "ConfigRoot" -Value "\var\vcap\jobs\dd-agent-windows\config\"
New-Item -Force -Path "\var\vcap\jobs\dd-agent-windows\config\" -Name "logs" -ItemType "directory"

# Start the idempotent agent installer
Start-Process -NoNewWindow -Wait "\var\vcap\packages\dd-agent-windows\Datadog\bin\agent\install-cmd.exe" -ArgumentList "-bindir \var\vcap\packages\dd-agent-windows\Datadog\ -confdir \var\vcap\jobs\dd-agent-windows\config\"

# Ensure the ddagentuser user dd-agent-windows package directory
icacls \var\vcap\packages\dd-agent-windows\Datadog\ /inheritance:e /grant "ddagentuser:(OI)(CI)(RX,WDAC)"
icacls \var\vcap\packages\dd-agent-windows\Datadog\ /inheritance:e /grant "ddagentuser:(OI)(CI)" /T

# Start the main Agent service. This will start the appropriate subservices if enabled (trace, logs, etc)
Start-Service datadogagent
