# Datadog Agent release for BOSH

* For Debian and RHEL/CentOS based stemcells
* Automatically defines tags based on deployments, names and jobs
* Process, network, ntp and disk integrations by default
* Monit processes are added automatically to process integration
* You can define additional integrations


# What this does

This includes the Debian and RHEL/CentOS releases in the package and unpacks them in the dd-agent directory.

While a source install would be preferable, we're balancing a number of concerns.

1. We want to ensure a consistent deployment among all customers.
1. We want to ensure a quick deployment.

Compiling Python takes a very long time (it took up to 30 minutes for Python alone on some machines we tested it on).
We also saw some disparities on some machines. It can creates issues if it stomps on the system python (which is hard to avoid in some cases) and it sometimes doesn't work.

So, our solution for this was to use our embedded python that we already have in our packages and unpack those packages (rather than installing them).


# Versioning

The BOSH release version follows the scheme:

`cf_major.cf_minor.agent_version`

The first two parts are the BOSH packaging versioning, and the third part is the packaged agent version, without the dot separator.

# Configuration

Upload the release to Bosh director

Create a `runtime-config.yaml` file:
```
releases:
- name: datadog-agent
  version: 1

addons:
- name: dd-agent
  jobs:
  - name: dd-agent
    release: datadog-agent
    properties:
      dd:
        use_dogstatsd: yes
        api_key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
        tags: ["datadog", "bosh", "bosh:bosh-exp"]

tags:
  owner: datadog
  email: support@datadoghq.com
```

Upload runtime-config to Bosh Director: `bosh update runtime-config runtime-config.yaml`

Re-deploy the deployments to automatically add the agent.


# Development

This repository contains only the packaging pieces for the agent to be deployed with [Cloud Foundry BOSH][2].
The Datadog Agent itself is added as a blob, and contributions to it are accepted [here][1].

See [here][3] for more information about the structure of a BOSH release.


# Authors

Datadog (opensource@datadoghq.com)

Based on the [datadog-agent-boshrelease][4] project by [Springer Nature Platform Engineering][5]

# Contribute

If you notice a limitation or a bug with the BOSH packaging of the agent, feel free to open a Github issue or submit a PR on this repository.
If the issue is with the agent itself, check out the [Datadog Agent repository][1] for issues and PR.

# Support

Support for this project is available via standard [Datadog support channels][6].

# License

[Apache 2.0 License](LICENSE)

[1]: https://github.com/DataDog/datadog-agent
[2]: https://github.com/cloudfoundry/bosh
[3]: https://bosh.io/docs/create-release/
[4]: https://github.com/SpringerPE/datadog-agent-boshrelease
[5]: https://github.com/SpringerPE/
[6]: https://docs.datadoghq.com/help/
