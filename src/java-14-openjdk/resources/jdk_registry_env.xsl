<?xml version="1.0" encoding="UTF-8"?>
<!--
 Copyright 2020 Red Hat, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:w="http://schemas.microsoft.com/wix/2006/wi" exclude-result-prefixes="w">

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="w:Directory[@Id='INSTALLDIR']">
        <Directory Id="INSTALLDIR" xmlns="http://schemas.microsoft.com/wix/2006/wi">
            <xsl:apply-templates select="@* | *"/>
        </Directory>

        <!-- jdk_registry_standard -->
        <Component Id="jdk_registry_standard_jdk" Guid="924cde70-aaf6-43f0-a86e-3b7d72716e83" Win64="yes" xmlns="http://schemas.microsoft.com/wix/2006/wi">
            <RegistryKey Id="jdk_registry_standard_jdk_key" ForceCreateOnInstall="yes" Root="HKLM"
                         Key="Software\JavaSoft\JDK\${${PROJECT_NAME}_MAJOR_VERSION}.0.${${PROJECT_NAME}_UPDATE}">
                <RegistryValue Name="JavaHome" Value="[INSTALLDIR]" Type="string"/>
                <RegistryValue Name="RuntimeLib" Value="[INSTALLDIR]bin\server\jvm.dll" Type="string"/>
            </RegistryKey>
        </Component>
        <Component Id="jdk_registry_standard_jdk_major" Guid="3e0dc8bc-9ff1-452b-b326-432617cce407" Win64="yes" xmlns="http://schemas.microsoft.com/wix/2006/wi">
            <RegistryKey Id="jdk_registry_standard_jdk_major_key" ForceCreateOnInstall="yes" Root="HKLM"
                         Key="Software\JavaSoft\JDK\${${PROJECT_NAME}_MAJOR_VERSION}.0">
                <RegistryValue Name="JavaHome" Value="[INSTALLDIR]" Type="string"/>
                <RegistryValue Name="RuntimeLib" Value="[INSTALLDIR]bin\server\jvm.dll" Type="string"/>
            </RegistryKey>
        </Component>
        <Component Id="jdk_registry_standard_jdk_version" Guid="335315af-e1c5-4178-9db9-c34c4e25a2ac" Win64="yes" xmlns="http://schemas.microsoft.com/wix/2006/wi">
            <RegistryKey Id="jdk_registry_standard_jdk_version_key" ForceCreateOnInstall="yes" Root="HKLM"
                         Key="Software\JavaSoft\JDK">
                <RegistryValue Name="CurrentVersion" Value="${${PROJECT_NAME}_MAJOR_VERSION}.0.${${PROJECT_NAME}_UPDATE}" Type="string"/>
            </RegistryKey>
        </Component>

        <!-- jdk_env_path -->
        <Component Id="jdk_env_path_comp" Guid="d84cb2f5-b3a1-478b-a104-b1defb1b4e32" KeyPath="yes" Win64="yes" xmlns="http://schemas.microsoft.com/wix/2006/wi">
            <Environment Id="jdk_env_path_key" Name="PATH" Value="[INSTALLDIR]bin" Action="set" Part="last" System="yes"/>
        </Component>

        <!-- jdk_env_java_home -->
        <Component Id="jdk_env_java_home_comp" Guid="ab00a37f-51f7-444f-94f8-58a73dcd1199" KeyPath="yes" Win64="yes" xmlns="http://schemas.microsoft.com/wix/2006/wi">
            <Environment Id="jdk_env_java_home_key" Name="JAVA_HOME" Value="[INSTALLDIR]" Action="set" Part="all" System="yes"/>
        </Component>

        <!-- jdk_env_vendor_java_home -->
        <Component Id="jdk_env_vendor_java_home_comp" Guid="f16ce77f-28df-4a09-a179-d3652f3bb5e8" KeyPath="yes" Win64="yes" xmlns="http://schemas.microsoft.com/wix/2006/wi">
            <Environment Id="jdk_env_vendor_java_home_key" Name="${${PROJECT_NAME}_VENDOR_UPPERCASE}_JAVA_HOME" Value="[INSTALLDIR]" Action="set" Part="all" System="yes"/>
        </Component>

        <!-- jdk_registry_jar -->
        <Component Id="jdk_registry_jar_content_type" Guid="a7a1e8ff-4330-4af4-9187-7bac58ed65a3" Win64="yes" xmlns="http://schemas.microsoft.com/wix/2006/wi">
            <RegistryKey Id="jdk_registry_jar_content_type_key" ForceCreateOnInstall="yes" Key="SOFTWARE\Classes\.jar" Root="HKLM">
                <RegistryValue Value="JARFile" Type="string"/>
                <RegistryValue Name="Content Type" Value="application/java-archive" Type="string"/>
            </RegistryKey>
        </Component>
        <Component Id="jdk_registry_jar_file_type" Guid="d33aad69-4256-4ee8-b46b-169299847803" Win64="yes" xmlns="http://schemas.microsoft.com/wix/2006/wi">
            <RegistryKey Id="jdk_registry_jar_file_type_key" ForceCreateOnInstall="yes" Key="SOFTWARE\Classes\JARFile" Root="HKLM">
                <RegistryValue Value="JAR File" Type="string"/>
                <RegistryValue Name="EditFlags" Value="65536" Type="integer"/>
            </RegistryKey>
        </Component>
        <Component Id="jdk_registry_jar_menu" Guid="90e4cbbd-72c3-4be0-a30f-6ae36b14a0d5" Win64="yes" xmlns="http://schemas.microsoft.com/wix/2006/wi">
            <RegistryKey Id="jdk_registry_jar_menu_key" ForceCreateOnInstall="yes" Key="SOFTWARE\Classes\JARFile\Shell\Open" Root="HKLM">
                <RegistryValue Value="&amp;Launch with ${${PROJECT_NAME}_VENDOR_SHORT} OpenJDK" Type="string"/>
            </RegistryKey>
        </Component>
        <Component Id="jdk_registry_jar_cmd" Guid="0c986426-006f-4737-b589-e2df4324fd4c" Win64="yes" xmlns="http://schemas.microsoft.com/wix/2006/wi">
            <RegistryKey Id="jdk_registry_jar_cmd_key" ForceCreateOnInstall="yes" Key="SOFTWARE\Classes\JARFile\Shell\Open\Command" Root="HKLM">
                <RegistryValue Value="&quot;[INSTALLDIR]bin\javaw.exe&quot; -jar &quot;%1&quot; %*" Type="string"/>
            </RegistryKey>
        </Component>

    </xsl:template>
    <xsl:template match="w:Feature[@Id='jdk']">
        <Feature Id="jdk" xmlns="http://schemas.microsoft.com/wix/2006/wi">
            <xsl:apply-templates select="@* | *"/>
            <Feature Id="jdk_registry_standard" Absent="allow" AllowAdvertise="no" Level="${${PROJECT_NAME}_INSTALLER_FEATURE_LEVEL}"
                     Title="Windows Registry"
                     Description="Adds 'JavaHome' and 'RuntimeLib' Windows Registry keys under 'HKLM\Software\JavaSoft'."
                     xmlns="http://schemas.microsoft.com/wix/2006/wi">
                <ComponentRef Id="jdk_registry_standard_jdk"/>
                <ComponentRef Id="jdk_registry_standard_jdk_major"/>
                <ComponentRef Id="jdk_registry_standard_jdk_version"/>
            </Feature>
            <Feature Id="jdk_env_path" Absent="allow" AllowAdvertise="no" Level="${${PROJECT_NAME}_INSTALLER_FEATURE_LEVEL}"
                     Title="PATH Variable"
                     Description="Appends '&lt;jdk&gt;/bin' to the 'PATH' system environment variable."
                     xmlns="http://schemas.microsoft.com/wix/2006/wi">
                <ComponentRef Id="jdk_env_path_comp"/>
            </Feature>
            <Feature Id="jdk_env_java_home" Absent="allow" AllowAdvertise="no" Level="2"
                     Title="JAVA_HOME Variable"
                     Description="Sets 'JAVA_HOME' system environment variable."
                     xmlns="http://schemas.microsoft.com/wix/2006/wi">
                <ComponentRef Id="jdk_env_java_home_comp"/>
            </Feature>
            <Feature Id="jdk_env_vendor_java_home" Absent="allow" AllowAdvertise="no" Level="2"
                     Title="${${PROJECT_NAME}_VENDOR_UPPERCASE}_JAVA_HOME Variable"
                     Description="Sets '${${PROJECT_NAME}_VENDOR_UPPERCASE}_JAVA_HOME' system environment variable."
                     xmlns="http://schemas.microsoft.com/wix/2006/wi">
                <ComponentRef Id="jdk_env_vendor_java_home_comp"/>
            </Feature>
            <Feature Id="jdk_registry_jar" Absent="allow" AllowAdvertise="no" Level="2"
                     Title="JAR Files Association"
                     Description="Allows to run JAR files from Windows Explorer."
                     xmlns="http://schemas.microsoft.com/wix/2006/wi">
                <ComponentRef Id="jdk_registry_jar_content_type"/>
                <ComponentRef Id="jdk_registry_jar_file_type"/>
                <ComponentRef Id="jdk_registry_jar_menu"/>
                <ComponentRef Id="jdk_registry_jar_cmd"/>
            </Feature>
        </Feature>
    </xsl:template>

</xsl:stylesheet>
