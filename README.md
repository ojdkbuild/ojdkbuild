About
-----

This project customizes the [Community builds using source code from OpenJDK](https://github.com/ojdkbuild/ojdkbuild) project by adapting default installation parameters to match the needs of [Informex SA/NV](https://www.informex.be/) customers. It provides tools to build binaries and installers using source code of [OpenJDK](http://openjdk.java.net/) (and its dependencies) from [CentOS](https://www.centos.org/) project.

Windows binaries are built with an attempt to keep them as close as possible in behaviour to `java-x-openjdk` [CentOS packages](https://git.centos.org/summary/?r=rpms/java-1.8.0-openjdk).

Info links:

 - [wiki page with a background information about the project](https://github.com/ojdkbuild/ojdkbuild/wiki/Motivation)
 - [overview of other OpenJDK builds](https://blog.joda.org/2018/09/time-to-look-beyond-oracles-jdk.html)
 - [differences from other OpenJDK 8 builds](https://stackoverflow.com/a/52218632)
 - [on CVEs lists](https://security.stackexchange.com/q/175611)

For more information on the Community builds using source code from OpenJDK, please refer to https://github.com/ojdkbuild/ojdkbuild

FAQ
---

Question 1:

 - Q: Will [Informex SA/NV](https://www.informex.be/) provide any technical support for the binaries distributed through this project?
 - A: Only to Informex customers, in the scope of Informex products usage. Support will only be provided via the customer support channels (phone/email). No support will be provided to other parties.

Question 2:

 - Q: Is this project endorsed by upstream [OpenJDK](http://openjdk.java.net/) project or by the [Community builds using source code from OpenJDK](https://github.com/ojdkbuild/ojdkbuild/) project?
 - A: No.

Update schedule
---------------

Builds are going to be updated on a best effort basis.

License
-------
This project is released under the [GNU GPL v. 2 with classpath exception](https://github.com/informex/ojdkbuild/blob/master/LICENSE).

Community builds using source code from OpenJDK project are released under the [GNU GPL v. 2 with classpath exception](https://github.com/ojdkbuild/ojdkbuild/blob/master/LICENSE).

OpenJDK binaries are released under the [GNU GPL v. 2 with classpath exception](https://github.com/ojdkbuild/ojdkbuild/blob/master/LICENSE).

Project icon is taken from [Nuvola icon set](https://en.wikipedia.org/wiki/Nuvola), it is released under the [GNU LGPL v. 2.1](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html).

Build scripts are released under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).

Other sources and binaries in this project (cygwin, freetype etc.) are released under their corresponding licenses.

Changelog
---------

**2018-11-21**

 * Fork & first build for `1.8.0.191-1`, with custom installation parameters
