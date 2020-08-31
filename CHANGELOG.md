# Changelog

## 3.2.0 / 2020-08-31

* [Fixed] Quote cluster agent token in config so that it doesn't get interpreted as number. See [#127](https://github.com/DataDog/datadog-agent-boshrelease/pull/127).
* [Added] Bump embedded Datadog Agent version to 7.22.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/master/CHANGELOG.rst#7220--6220).

## 3.1.0 / 2020-07-24

* [Fixed] Make Python checks use the system CA store. See [#125](https://github.com/DataDog/datadog-agent-boshrelease/pull/125).
* [Added] Bump embedded Datadog Agent version to 7.21.1. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/master/CHANGELOG.rst#7211).

## 3.0.0 / 2020-06-18

* [Added] Bump embedded Datadog Agent version to 7.20.2, which adds support for application container discovery. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/master/CHANGELOG.rst#7202)
* [Added] Add support for DCA and cluster checks for integrations autodiscovery. See [#119](https://github.com/DataDog/datadog-agent-boshrelease/pull/119).

Note: With these two new major features, the versioning scheme of the Datadog Agent Bosh Release changes from `major.minor.embedded_agent_version` to a strict Semver format.
