# Changelog

## 4.12.2 / 2022-11-28

Fixes a `missing .deb package error` introduced in the previous release.

## 4.12.1 / 2022-11-16

* [Added] Bump embedded Datadog Agent version to 7.40.2\~pcf\~beta\~container\~tagger\~image. It consists of the Datadog Agent version 7.40.1 in addition to this [fix](https://github.com/DataDog/datadog-agent/pull/14267). Image branch [here](https://github.com/DataDog/datadog-agent/tree/7.40.2-pcf-beta-container-tagger-image)

## 4.12.0 / 2022-11-14

* [Added] Bump embedded Datadog Agent version to 7.40.1. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7401--6401).

## 4.11.2 / 2022-10-11

* [Fixed] Fix system-probe ownership issue. Read more about it [here](https://github.com/DataDog/datadog-agent-boshrelease/pull/176).

## 4.11.1 / 2022-08-17

* [Added] Increase monit stop timeout from 30s (default) to 90s. Read more about it [here](https://github.com/DataDog/datadog-agent-boshrelease/pull/174).

## 4.11.0 / 2022-08-03

* [Added] Bump embedded Datadog Agent version to 7.37.1. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7371--6371).

## 4.10.0 / 2022-06-09

* [Added] Bump embedded Datadog Agent version to 7.36.1. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7361--6361).

## 4.9.2 / 2022-04-13

* [Added] Bump embedded Datadog Agent version to 7.35.1. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7351--6351).

## 4.9.1 / 2022-02-24

* [Added] Add option to disable Network Performance Monitoring when enabling system probe. See [#164](https://github.com/DataDog/datadog-agent-boshrelease/pull/164).
* [Fixed] Fix option to enable/disable trace agent. See [#166](https://github.com/DataDog/datadog-agent-boshrelease/pull/166).

## 4.9.0 / 2022-02-07

* [Added] Bump embedded Datadog Agent version to 7.33.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7330--6330).
* [Fixed] Fix socket ownership issue related to system-probe and process-agent communication. See [#162](https://github.com/DataDog/datadog-agent-boshrelease/pull/162).

## 4.8.3 / 2021-12-22

* [Added] Bump embedded Datadog Agent version to 7.32.4. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7324--6324).

## 4.8.2 / 2021-12-20

* [Added] Bump embedded Datadog Agent version to 7.32.3. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7323--6323).

## 4.8.1 / 2021-12-13

* [Added] Bump embedded Datadog Agent version to 7.32.2. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7322--6322).

## 4.8.0 / 2021-11-24

* [Added] Bump embedded Datadog Agent version to 7.32.1. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7321--6321).

## 4.7.1 / 2021-09-21

* [Added] Downgrade embedded Datadog Agent version to 7.27.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/master/CHANGELOG.rst#7270--6270).

## 4.7.0 / 2021-09-20

* [Added] Bump embedded Datadog Agent version to 7.31.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/main/CHANGELOG.rst#7310--6310).

## 4.6.0 / 2021-08-16

* [Added] Add option to collect monit children processes in process check. See [#155](https://github.com/DataDog/datadog-agent-boshrelease/pull/155).
* [Added] Add option to force use of TLS 1.2. See [#153](https://github.com/DataDog/datadog-agent-boshrelease/pull/153).
* [Fixed] Always set `no_proxy_nonexact_match` option if specified. See [#152](https://github.com/DataDog/datadog-agent-boshrelease/pull/152).
* [Added] Bump embedded Datadog Agent version to 7.30.0. Read more about it [here](https://github.com/DataDog/datadog-agent/blob/master/CHANGELOG.rst#7300--6300).

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
