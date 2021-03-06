# Smoke Test plugin

[![Build Status][xld-smoke-test-plugin-travis-image]][xld-smoke-test-plugin-travis-url]
[![Codacy Badge][xld-smoke-test-plugin-codacy-image] ][xld-smoke-test-plugin-codacy-url]
[![Code Climate][xld-smoke-test-plugin-code-climate-image] ][xld-smoke-test-plugin-code-climate-url]
[![License: MIT][xld-smoke-test-plugin-license-image] ][xld-smoke-test-plugin-license-url]
[![Github All Releases][xld-smoke-test-plugin-downloads-image] ]()


[xld-smoke-test-plugin-travis-image]: https://travis-ci.org/xebialabs-community/xld-smoke-test-plugin.svg?branch=master
[xld-smoke-test-plugin-travis-url]: https://travis-ci.org/xebialabs-community/xld-smoke-test-plugin
[xld-smoke-test-plugin-codacy-image]: https://api.codacy.com/project/badge/Grade/49e14532522f4d6f8326b1899efd8cd3
[xld-smoke-test-plugin-codacy-url]: https://www.codacy.com/app/joris-dewinne/xld-smoke-test-plugin
[xld-smoke-test-plugin-code-climate-image]: https://codeclimate.com/github/xebialabs-community/xld-smoke-test-plugin/badges/gpa.svg
[xld-smoke-test-plugin-code-climate-url]: https://codeclimate.com/github/xebialabs-community/xld-smoke-test-plugin
[xld-smoke-test-plugin-license-image]: https://img.shields.io/badge/License-MIT-yellow.svg
[xld-smoke-test-plugin-license-url]: https://opensource.org/licenses/MIT
[xld-smoke-test-plugin-downloads-image]: https://img.shields.io/github/downloads/xebialabs-community/xld-smoke-test-plugin/total.svg

## Overview

The Smoke Test plugin is an XL Deploy plugin that triggers http requests at the end of the deployment task. It uses either `wget` executable file (Unix / Windows) or `Invoke-WebRequest` PowerShell cmdlet (Windows).

## Requirements

* **XL Deploy requirements**
	* **XL Deploy**: version 6.0.+

## Installation

Place the plugin `xldp` file into your `SERVER_HOME/plugins` directory.

## Usage

A `smoketest.Runner` CI is a container from which the test will be performed.

3 Deployables are provided that will be deployed onto a `smoketest.Runner`

* `smoketest.HttpRequestTest` for a HTTP request using the GET verb
* `smoketest.HttpPostRequestTest` for a HTTP request using the POST verb
* `smoketest.HttpPostRequestFileTest` for a HTTP request using the POST verb and a file that contains the post data.

## Expected and Unexpected text

You can specify what text you expect to be in the response, like version numbers. And/or you can specify the text that should not be in the response, like error statements.


## Note

On Unix hosts, the plugin will use `wget`that should be already installed.
On Windows hosts, there are 2 options

* use a version of `wget` bundled in the plugin and uploaded to perform the http request. (default option)
* use a PowerShell implementation. To activate this option you need to
** enable the property powershellInstalled` on the `smoketest.Runner`
** install PowerShell v3+ on the remote Windows Host.


If you wish to use a _different_ `wget` that is _already present_ on the path of your target systems you can simply prevent the included version from being uploaded by modifying `SERVER_HOME/conf/deployit-defaults.properties` as follows:

	# Classpath Resources
	# smokeTest.ExecutedHttpRequestTest.classpathResources=smoketest/runtime/wget.exe

to

	# Classpath Resources
	smokeTest.ExecutedHttpRequestTest.classpathResources=


![XLD Smoke Test plugin in action](images/xld-smoke-test-inaction.png)


# Sample App

```
xl apply --xl-deploy-url http://localhost:4540 -f xebialabs.yaml

[1/4] Applying infrastructure.yaml (imported by xebialabs.yaml)
    Created CI Infrastructure/xld-smoke-test/localhost/test runner
    Created CI Infrastructure/xld-smoke-test/localhost
    Created CI Infrastructure/xld-smoke-test

[2/4] Applying environments.yaml (imported by xebialabs.yaml)
    Created CI Environments/xld-smoke-test/dev
    Created CI Environments/xld-smoke-test/dev.conf
    Created CI Environments/xld-smoke-test

[3/4] Applying applications.yaml (imported by xebialabs.yaml)
    Created CI Applications/xld-smoke-test/postcodes.io/1.0/manual test
    Created CI Applications/xld-smoke-test/postcodes.io/1.0/get
    Created CI Applications/xld-smoke-test/postcodes.io/1.0/post file
    Created CI Applications/xld-smoke-test/postcodes.io/1.0/post
    Created CI Applications/xld-smoke-test/postcodes.io/1.0
    Created CI Applications/xld-smoke-test/postcodes.io
    Created CI Applications/xld-smoke-test

[4/4] Applying xebialabs.yaml
Done
``
