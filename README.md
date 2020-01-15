# Datadog Agent releases for BOSH

* For Debian, RHEL/CentOS and Windows based stemcells
* Automatically defines tags based on deployments, names and jobs
* Process, network, ntp and disk integrations by default
* Monit processes are added automatically to process integration
* You can define additional integrations


# What this does

This includes jobs for the Debian and RHEL/CentOS releases in the package and unpacks them in the dd-agent/dd-agent-windows directory.

While a source install would be preferable, we're balancing a number of concerns.

1. We want to ensure a consistent deployment among all customers.
1. We want to ensure a quick deployment.

Compiling Python takes a very long time (it took up to 30 minutes for Python alone on some machines we tested it on).
We also saw some disparities on some machines. It can creates issues if it stomps on the system python (which is hard to avoid in some cases) and it sometimes doesn't work.

So, our solution for this was to use our embedded python that we already have in our packages and unpack those packages (rather than installing them).


# Versioning

We version the bosh release with the following scheme:

`cf_major.cf_minor.agent_version`

The first three are directly from the agent itself, they reflect the current agent version. The final one is the CF version, as there may be cause to release more than one during an agent bugfix.


# Configuration

Upload the release to Bosh director
There are two distinct releases, one for the Linux stemcells, and the other for windows; dd-agent and dd-agent-windows respectively. These jobs accept the same properties, they only differ in release name.

Create a `runtime-config.yaml` file:
```
releases:
- name: datadog-agent
  version: 1

addons:
- name: dd-agent
  jobs:
  - name: dd-agent
    release: <datadog-agent/datadog-agent-windows>
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

Since there's almost no code here, just add your checks to checks.d and get going!

There is a script `prepare,` which grabs all the relevant blobs gets everything ready to release.
```
./prepare <JOB_NAME>
```

where <JOB_NAME> is either `dd-agent` or `dd-agent-windows` depending on your OS.

It will get all sources specified in the packages/\*/spec files for local development.

The default blobstore is our s3 bucket, however you can change this to any blobstore you like. We have a yaml file set up to use a local blobstore as well, if for some reason you cannot use a remote one.


# Authors
Datadog (opensource@datadoghq.com)

Based on the [https://github.com/SpringerPE/datadog-agent-boshrelease](https://github.com/SpringerPE/datadog-agent-boshrelease) project by [Springer Nature Platform Engineering](https://github.com/SpringerPE/)

# Contribute

If you notice a limitation or a bug with this project, feel free to open a Github issue or submit a PR.

# Support

Support for this project is available via standard [Datadog support channels](http://docs.datadoghq.com/help/).

# License

Apache 2.0 License
