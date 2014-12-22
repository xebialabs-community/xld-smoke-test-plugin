# Smoke Test plugin #

# Overview #

The Smoke Tests plugin is an XL Deploy plugin that trigger http request at the end of the deployment tasks.

# Requirements #

* **Deployit requirements**
	* **Deployit**: version 4.5.+

# Installation #

Place the plugin JAR file into your `SERVER_HOME/plugins` directory.

# Usage #

On Windows hosts, the plugin will by default use a version of `wget` included in the plugin. If you wish to use a _different_ `wget` that is _already present_ on the path of your target systems you can simply prevent the included version from being uploaded by modifying `SERVER_HOME/conf/deployit-defaults.properties` as follows:

	# Classpath Resources
	# smokeTest.ExecutedHttpRequestTest.classpathResources=tests2/runtime/wget.exe

to

	# Classpath Resources
	smokeTest.ExecutedHttpRequestTest.classpathResources=

