# Changelog

## 4.5.0 / 2021-04-20

* [Added] Add `no_proxy_nonexact_match` configuration option. See [#150](https://github.com/DataDog/datadog-agent-boshrelease/pull/150).
* [Added] Add properties to configure custom URLs for process, APM and logs. See [#149](https://github.com/DataDog/datadog-agent-boshrelease/pull/149).
* [Added] Add ability to configure process agent for container collection only. See [#145](https://github.com/DataDog/datadog-agent-boshrelease/pull/145).
* [Added] Bump embedded Datadog Agent version to 7.27.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/master/CHANGELOG.rst#7270--6270).

## 4.4.1 / 2021-03-25

* [Fixed] Fix appending VM GUID to friendly hostname. See [#147](https://github.com/DataDog/datadog-agent-boshrelease/pull/147).

## 4.4.0 / 2021-03-18

* [Added] Add option to append VM UUID to generated friendly hostnames. See [#144](https://github.com/DataDog/datadog-agent-boshrelease/pull/144).
* [Fixed] Fix issue with process check when trying to access BPM processes. See [#143](https://github.com/DataDog/datadog-agent-boshrelease/pull/143).
* [Fixed] Fixed hostname generation issue. See [#142](https://github.com/DataDog/datadog-agent-boshrelease/pull/142).
* [Added] Bump embedded Datadog Agent version to 7.26.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/master/CHANGELOG.rst#7260--6260).

## 4.3.0 / 2021-01-21

* [Added] Bump embedded Datadog Agent version to 7.25.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/master/CHANGELOG.rst#7250--6250).

## 4.2.0 / 2020-12-14

* [Fixed] Source files at start only to avoid unnecessary operations during stop. See [#136](https://github.com/DataDog/datadog-agent-boshrelease/pull/136).
* [Added] Bump embedded Datadog Agent version to 7.24.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/master/CHANGELOG.rst#7240--6240).

## 4.1.0 / 2020-10-13

* [Fixed] Specify aggregates and percentiles as arrays in Datadog agent config. See [#134](https://github.com/DataDog/datadog-agent-boshrelease/pull/134). Thanks [anto-daniel](https://github.com/anto-daniel).
* [Added] Bump embedded Datadog Agent version to 7.23.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/master/CHANGELOG.rst#7230--6230).

## 4.0.1 / 2020-09-18

* [Fixed] Properly duplicate new DCA settings in system probe configuration. See [#132](https://github.com/DataDog/datadog-agent-boshrelease/pull/132).
* [Fixed] Configure path to eBPF libraries for system probe. See [#131](https://github.com/DataDog/datadog-agent-boshrelease/pull/131).
* [Fixed] Bump embedded Datadog Agent version to 7.22.1. In particular, this fixes segfaults in the process agent when collecting application containers in error state. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/7.22.x/CHANGELOG.rst#7221--6221).

## 4.0.0 / 2020-09-04

* [Changed] Remove usage of Bosh links in favor of DNS aliases. See [#129](https://github.com/DataDog/datadog-agent-boshrelease/pull/129).

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
