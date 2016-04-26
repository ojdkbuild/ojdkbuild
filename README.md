Download
--------

 - [TODO java-1.8.0-openjdk-1.8.0.91-2.b14.windows.x86_64.zip](TODO)

About
-----

This project provides binaries built using source code of [OpenJDK](http://openjdk.java.net/) (and its dependencies) from [Red Hat Enterprise Linux](https://en.wikipedia.org/wiki/Red_Hat_Enterprise_Linux) that is [publicly available](http://ftp.redhat.com/redhat/linux/enterprise/7Server/en/os/README) through [CentOS](https://www.centos.org/) infrastructure.

Binaries are built with an attempt to keep them as close as possible in behaviour to `java-1.x.0-openjdk` RHEL packages.

Currently only `windows.x86_64` platform is supported, other platforms may be added in future.

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

Build scipts are released under the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0).

Other sources and binaries in this project (cygwin, freetype etc.) are released under their corresponding licenses.

Changelog
---------

**2016-04-26**

  * `8u91-2` build

