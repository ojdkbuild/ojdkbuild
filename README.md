Downloads for Windows x86_64
----------------------------

_Note: obsolete downloads are available at the bottom of this page._

 - **1.8.0_111-1** ([announcement](https://groups.google.com/d/msg/ojdkbuild/dOjI3pgkeP0/EOEJ7R46CgAJ))
  - [java-1.8.0-openjdk-1.8.0.111-1.b15.ojdkbuild.windows.x86_64.zip](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.111-1/java-1.8.0-openjdk-1.8.0.111-1.b15.ojdkbuild.windows.x86_64.zip) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-1.8.0.111-1.b15.ojdkbuild.windows.x86_64.zip.sha256))
  - [java-1.8.0-openjdk-1.8.0.111-1.b15.ojdkbuild.windows.x86_64.msi](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.111-1/java-1.8.0-openjdk-1.8.0.111-1.b15.ojdkbuild.windows.x86_64.msi) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-1.8.0.111-1.b15.ojdkbuild.windows.x86_64.msi.sha256))

Other downloads
---------------

**Linux x86_64 ([issue](https://github.com/ojdkbuild/ojdkbuild/issues/1))**

 - **1.8.0_111** ([announcement](https://groups.google.com/d/msg/ojdkbuild/dOjI3pgkeP0/EOEJ7R46CgAJ))
  - [java-1.8.0-openjdk-1.8.0.111-0.b15.el6_8.x86_64.zip](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.111-1/java-1.8.0-openjdk-1.8.0.111-0.b15.el6_8.x86_64.zip) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-1.8.0.111-0.b15.el6_8.x86_64.zip.sha256))

**Linux ARM32**

_Note: for Fedora ARM32 please see [openjdk-aarch32](https://admin.fedoraproject.org/pkgdb/package/rpms/java-1.8.0-openjdk-aarch32/) RPM package in main repository._

 - **1.8.0_102-1** ([announcement](https://groups.google.com/d/msg/ojdkbuild/HFkbNsyt9B8/fqda374lAAAJ))
  - [java-1.8.0-openjdk-aarch32-1.8.0.102-1.b14.ojdkbuild.jessie.armv6.zip](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.102-2/java-1.8.0-openjdk-aarch32-1.8.0.102-1.b14.ojdkbuild.jessie.armv6.zip) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-aarch32-1.8.0.102-1.b14.ojdkbuild.jessie.armv6.zip.sha256))
  - [java-1.8.0-openjdk-aarch32-1.8.0.102-1.b14.ojdkbuild.xenial.armv7.zip](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.102-2/java-1.8.0-openjdk-aarch32-1.8.0.102-1.b14.ojdkbuild.xenial.armv7.zip) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-aarch32-1.8.0.102-1.b14.ojdkbuild.xenial.armv7.zip.sha256))

About
-----

This project provides binaries built using source code of [OpenJDK](http://openjdk.java.net/) (and its dependencies) from [CentOS](https://www.centos.org/) project.

Windows binaries are built with an attempt to keep them as close as possible in behaviour to `java-1.x.0-openjdk` [CentOS packages](https://git.centos.org/summary/?r=rpms/java-1.8.0-openjdk).

Linux binaries are not being built from the sources of this projects. `x86_64` ones are extracted from CentOS 6 binary packages instead, see details in [CentOS6ZipBundle](https://github.com/ojdkbuild/ojdkbuild/wiki/CentOS6ZipBundle). `AArch32` ones are built from the sources available in [AArch32 Port](http://openjdk.java.net/projects/aarch32-port/) project repositories.

FAQ
---

Question 1:

 - Q: Will [Red Hat, Inc.](https://www.redhat.com/en) provide any technical support for the binaries distributed through this project?
 - A: No.

Question 2:

 - Q: Is this project endorsed by upstream [OpenJDK](http://openjdk.java.net/) project?
 - A: No.

Question 3:

 - Q: Will any questions about the [TCK](https://en.wikipedia.org/wiki/Technology_Compatibility_Kit) be answered (regarding this project)?
 - A: No.

Update schedule
---------------

Builds are going to be updated once in three months after each corresponding [Oracle Critical Patch Updates](http://www.oracle.com/technetwork/topics/security/alerts-086861.html) release for Oracle Java.

How to build
------------

On `windows.x86_64`:

    git clone --recursive https://github.com/ojdkbuild/ojdkbuild.git
    cd ojdkbuild
    run.bat

Mailing list
------------

To see the collection of prior postings to the list, visit the [ojdkbuild Archives](https://groups.google.com/forum/#!forum/ojdkbuild).

To subscribe to the list, send email to: `ojdkbuild+subscribe@googlegroups.com`

To post a message to all the list members, send email to: `ojdkbuild@googlegroups.com`

License
-------

OpenJDK binaries are released under the [GNU GPL v. 2 with classpath exception](https://github.com/ojdkbuild/ojdkbuild/blob/master/LICENSE).

Project icon is taken from [Nuvola icon set](http://www.icon-king.com/projects/nuvola/), it is released under the [GNU LGPL v. 2.1](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html).

Build scipts are released under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).

Other sources and binaries in this project (cygwin, freetype etc.) are released under their corresponding licenses.

Changelog
---------

**2016-10-20**

 * `1.8.0_111-1` build

**2016-09-17**

 * `1.8.0_102-2` build

**2016-08-12**

 * `1.8.0_102-1` build

**2016-07-22**

 * `1.8.0_101-1` build

**2016-05-27**

 * `1.8.0_91` Linux bundle added

**2016-05-17**

  * `1.8.0_91-3` build
  * MSI installer 

**2016-04-26**

  * `1.8.0_91-2` build


Obsolete downloads for Windows x86_64
-------------------------------------

 - **1.8.0_102-2** ([announcement](https://groups.google.com/d/msg/ojdkbuild/HFkbNsyt9B8/fqda374lAAAJ))
  - [java-1.8.0-openjdk-1.8.0.102-2.b14.ojdkbuild.windows.x86_64.zip](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.102-2/java-1.8.0-openjdk-1.8.0.102-2.b14.ojdkbuild.windows.x86_64.zip) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-1.8.0.102-2.b14.ojdkbuild.windows.x86_64.zip.sha256))
  - [java-1.8.0-openjdk-1.8.0.102-2.b14.ojdkbuild.windows.x86_64.msi](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.102-2/java-1.8.0-openjdk-1.8.0.102-2.b14.ojdkbuild.windows.x86_64.msi) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-1.8.0.102-2.b14.ojdkbuild.windows.x86_64.msi.sha256))
 - **1.8.0_102-1** ([announcement](https://groups.google.com/d/msg/ojdkbuild/oVUgQb6KCbg/sDpbzZT-CQAJ))
  - [java-1.8.0-openjdk-1.8.0.102-1-ojdkbuild.b14.windows.x86_64.zip](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.102-1/java-1.8.0-openjdk-1.8.0.102-1-ojdkbuild.b14.windows.x86_64.zip) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-1.8.0.102-1-ojdkbuild.b14.windows.x86_64.zip.sha256))
  - [java-1.8.0-openjdk-1.8.0.102-1-ojdkbuild.b14.windows.x86_64.msi](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.102-1/java-1.8.0-openjdk-1.8.0.102-1-ojdkbuild.b14.windows.x86_64.msi) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-1.8.0.102-1-ojdkbuild.b14.windows.x86_64.msi.sha256))
 - **1.8.0_101-1** ([announcement](https://groups.google.com/d/msg/ojdkbuild/fFKQRnt8NtU/CNazJ8KFAwAJ))
  - [java-1.8.0-openjdk-1.8.0.101-1-ojdkbuild.b13.windows.x86_64.zip](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.101-1/java-1.8.0-openjdk-1.8.0.101-1-ojdkbuild.b13.windows.x86_64.zip) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-1.8.0.101-1-ojdkbuild.b13.windows.x86_64.zip.sha256))
  - [java-1.8.0-openjdk-1.8.0.101-1-ojdkbuild.b13.windows.x86_64.msi](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.101-1/java-1.8.0-openjdk-1.8.0.101-1-ojdkbuild.b13.windows.x86_64.msi) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-1.8.0.101-1-ojdkbuild.b13.windows.x86_64.msi.sha256))
 - **1.8.0_91-3** ([announcement](https://groups.google.com/d/msg/ojdkbuild/evdWEomOP5E/Ms2B1cz1CQAJ))
  - [java-1.8.0-openjdk-1.8.0.91-3.b14.windows.x86_64.zip](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.91-3/java-1.8.0-openjdk-1.8.0.91-3.b14.windows.x86_64.zip) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-1.8.0.91-3.b14.windows.x86_64.zip.sha256))
  - [java-1.8.0-openjdk-1.8.0.91-3.b14.windows.x86_64.msi](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.91-3/java-1.8.0-openjdk-1.8.0.91-3.b14.windows.x86_64.msi) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-1.8.0.91-3.b14.windows.x86_64.msi.sha256))
 - **1.8.0_91-2** ([announcement](https://groups.google.com/d/msg/ojdkbuild/WDXg0deZ57Q/K2G8eQiIBAAJ))
  - [java-1.8.0-openjdk-1.8.0.91-2.b14.windows.x86_64.zip](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.91-2/java-1.8.0-openjdk-1.8.0.91-2.b14.windows.x86_64.zip) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-1.8.0.91-2.b14.windows.x86_64.zip.sha256))


Other obsolete downloads
------------------------

**Linux x86_64 ([issue](https://github.com/ojdkbuild/ojdkbuild/issues/1))**

 - **1.8.0_101** ([announcement](https://groups.google.com/d/msg/ojdkbuild/fFKQRnt8NtU/CNazJ8KFAwAJ))
  - [java-1.8.0-openjdk-1.8.0.101-3.b13.el6_8.x86_64.zip](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.101-1/java-1.8.0-openjdk-1.8.0.101-3.b13.el6_8.x86_64.zip) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-1.8.0.101-3.b13.el6_8.x86_64.zip.sha256))
 - **1.8.0_91** ([announcement](https://groups.google.com/d/msg/ojdkbuild/CyhLLruQF0Y/NesYKYa7AAAJ))
  - [java-1.8.0-openjdk-1.8.0.91-1.b14.el6.x86_64.zip](https://github.com/ojdkbuild/ojdkbuild/releases/download/1.8.0.91-3/java-1.8.0-openjdk-1.8.0.91-1.b14.el6.x86_64.zip) ([sha256](https://github.com/ojdkbuild/ojdkbuild/blob/master/resources/checksums/java-1.8.0-openjdk-1.8.0.91-1.b14.el6.x86_64.zip.sha256))
