This repository contains a sample BOSH package to demonstrate how you would use [secrets backend feature of the Datadog agent](https://github.com/DataDog/datadog-agent/blob/master/docs/agent/secrets.md) in a CloudFoundry environment.

To build and use this package:
1. Run the following command to create the BOSH package archive
    ```bash
    bosh create-release --force --tarball=mock_secret_backend.tgz --version=1.0.0
    ```
1. Upload the `mock_secret_backend.tgz` release to your CloudFoundry environment
    ```bash
    bosh upload-release mock_secret_backend.tgz
    ```
1. Update the [runtime configuration](runtime-config.yaml) of your BOSH Director to deploy the secret backend binary contained in the BOSH package, so that it can be used by the Datadog agent
    ```bash
    bosh update-runtime-config runtime-config.yaml
    ```
1. The secret backend binary is available at `/var/vcap/packages/mock_secret_backend/mock_secret_backend.py`, so specify this path for the property `dd.secret_backend_command` of the Datadog agent runtime configuration.
1. Redeploy your VM to install the Datadog agent and the secret backend binary on it

The Datadog agent can now use the provided binary to decrypt secrets in your configurations.
