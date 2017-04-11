# Datadog Agent release for BOSH

* For debian and rpm based stemcells (more to come)
* Automatically defines tags based on deployments, names and jobs
* Process, network, ntp and disk integrations by default
* Monit processes are added automatically to process integration
* You can define additional integrations


# What this does

This includes the rpm and debian releases in the package and unpacks them in the dd-agent directory.

While a source install would be preferable, we're balancing a number of concerns.

1. We want to ensure a consistent deployment among all customers.
1. We want to ensure a quick deployment.

Compiling Python takes a very long time (it took up to 30 minutes for Python alone on some machines we tested it on).
We also saw some disparities on some machines. It can creates issues if it stomps on the system python (which is hard to avoid in some cases) and it sometimes doesn't work.

So, our solution for this was to use our embedded python that we already have in our packages and unpack those packages (rather than installing them).

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
      tags: ["pe", "bosh", "bosh:bosh-exp"]

tags:
  owner: pe
  email: platform-engineering@springernature.com
```

Upload runtime-config to Bosh Director: `bosh update runtime-config  runtime-config.yaml`

Re-deploy the deployments to automatically add the agent.

You can also add the release to the manifest and deploy it


# Development

Since there's almost no code here, just add your checks to checks.d and get going!

There is a script `bosh_prepare,` which grabs all the relevant blobs gets everything ready to release.
```
./bosh_prepare
```

It will get all sources specified in the packages/*/spec files (commented out) for
local development, then you can create the release (final) with:
```
./bosh_final_release
```
which will upload the tarball to github and make the new blobs public available in the S3 bucket


# Author

Springer Nature Platform Engineering, Jose Riguera Lopez (jose.riguera@springer.com)

Copyright 2017 Springer Nature
Copyright 2017 Datadog, Inc


# License

Apache 2.0 License
