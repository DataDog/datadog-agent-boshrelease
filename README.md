# datadog-firehose-nozzle-release

This is a BOSH release for the datadog-firehose-nozzle, which transports logs
from [Loggregator](https://github.com/cloudfoundry/loggregator) to [Datadog](https://www.datadoghq.com/).

## Building the Nozzle

First, you will need to grab all the submodules.

`git submodule update --init --recursive`.

Second, you will need to grab the firehose-nozzle golang dependencies. The Datadog Firehose Nozzle uses glide to manage its dependencies. If you want to build your own bosh release, you will need to run `./prepare`. That will install glide, if needed, and then install all the dependencies under vendor/ in the datadog firehose nozzle submodule under src.

Then, all you will need to do is run bosh prepare, and everything will be bundled up for you!

## Deploying the Nozzle

For a general guide to deploying nozzles, see [here](https://docs.cloudfoundry.org/loggregator/nozzle-tutorial.html).

This nozzle assumes you have a Cloud Foundry deployed with a UAA client for
the datadog nozzle. Configuration for the UAA client should look something
like the following.

```
uaa:
  clients:
    datadog-firehose-nozzle:
      access-token-validity: 1209600
      authorities: doppler.firehose
      authorized-grant-types: client_credentials
      override: true
      scope: doppler.firehose
      secret: datadog-password
```

Once a Datadog client is registered in UAA, you are ready to deploy the
nozzle. The instructions here assume you are using the Ruby based Bosh CLI and have this deployed on Bosh Lite.

### If you are using Bosh Lite

First, update `bosh-lite/stub.yml` with your Datadog API key.  Note that the
`client_secret` under the `uaa` section in `properties` will need to match
whatever password you set for the UAA client above.

Once the `stub.yml` reflects all the correct credentials, generate a manifest
with:

```
./scripts/make_manifest_spiff bosh-lite/stub.yml
```

### If you are not using Bosh Lite

If you are not usin Bosh Lite, your deployment will require more customization. If you look at the current templates, you'll get a good sense of what you'll need to do in order to deploy the firehose.

For an example manifest, check out `./manifests/examples/example_manifest.yml`

You are now ready to deploy:

```
bosh deploy
```
