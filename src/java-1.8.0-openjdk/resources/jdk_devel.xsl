<?xml version="1.0" encoding="UTF-8"?>
<!--
 Copyright 2019 Red Hat, Inc.

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

            <Directory Id="_2defecaf_1f64_4070_9274_340404af58d6" Name="bin">
                <Component Id="_1fdc4efc_b5e9_46fb_8fd9_6903e19527af" Guid="61a36cd2-613c-4776-a72f-fbde92f18631" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_b31feaa0_76b3_42d5_b953_cb402fc186a1" Name="appletviewer.exe" KeyPath="yes" DiskId="1" Source="devel\bin\appletviewer.exe"/>
                </Component>
                <Component Id="_ef0a35df_ddee_45cc_8f37_a01f6e8f322d" Guid="e9f0abd0-9df7-4f49-855c-05affaa793de" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_9e28584a_2c01_4477_ae6e_cc585c58a2f9" Name="clhsdb.exe" KeyPath="yes" DiskId="1" Source="devel\bin\clhsdb.exe"/>
                </Component>
                <Component Id="_2d92ecc9_2f6c_4fd3_b57b_f43b2666a239" Guid="1a70c8aa-f327-4829-aa16-0a84ecebc1c6" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_916b17d5_6e82_48ae_9a96_d1e322347f3c" Name="extcheck.exe" KeyPath="yes" DiskId="1" Source="devel\bin\extcheck.exe"/>
                </Component>
                <Component Id="_0d79ab43_5163_499d_9f65_8e61ac075768" Guid="30b2726c-4aa9-4e75-b61d-943c05c7d948" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_b8472430_4265_45ad_baba_b3742da187c3" Name="hsdb.exe" KeyPath="yes" DiskId="1" Source="devel\bin\hsdb.exe"/>
                </Component>
                <Component Id="_700a0975_27d0_4328_9700_dc6c38262c86" Guid="1ab5484b-1481-4ec3-a8fd-f1175beca546" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_f1c3f28c_a9ff_4026_b0a8_bc432d97e70e" Name="idlj.exe" KeyPath="yes" DiskId="1" Source="devel\bin\idlj.exe"/>
                </Component>
                <Component Id="_9dec4207_be6f_4e44_a179_3229ca9ff1e0" Guid="ff69444d-2aa9-450d-9689-117ac8c1af11" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_4ba18b41_ca69_41fc_8f9c_abbdfb29c9fe" Name="jabswitch.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jabswitch.exe"/>
                </Component>
                <Component Id="_30886f4f_2720_470e_9758_bbc675bda322" Guid="9b54ea48-fb26-47b5-964e-876cf8c5bfcf" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_a5710c19_719f_4a19_9324_f3e15390f0c2" Name="jar.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jar.exe"/>
                </Component>
                <Component Id="_a51ec78e_1ab2_4c3c_bbde_7054faf87787" Guid="99cb9eaa-e470-4875-874c-ae4200f9c2a6" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_d2bb49c5_9a72_45f5_aac8_cacc33441a30" Name="jarsigner.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jarsigner.exe"/>
                </Component>
                <Component Id="_f681e57c_3221_4f4e_9f8e_bdf659730819" Guid="8fcf5917-815c-4223-8c0f-0d0e405060f1" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_4a336d5f_2656_413b_82c5_8fa57f61da6b" Name="java-rmi.exe" KeyPath="yes" DiskId="1" Source="devel\bin\java-rmi.exe"/>
                </Component>
                <Component Id="_d5bf739a_d61e_4991_81e0_f48c6579535f" Guid="0479d73d-4b6c-442d-a61f-87960ca5a0be" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_f6214944_8365_485e_841b_b63cbe685fa4" Name="java.exe" KeyPath="yes" DiskId="1" Source="devel\bin\java.exe"/>
                </Component>
                <Component Id="_40704ef5_7acf_4d57_aa97_558ca216ea3a" Guid="4ec3179f-503f-484e-b0f8-a65f63bb1913" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_7d1804a9_f8f1_4e46_ade7_c5ed18557487" Name="javac.exe" KeyPath="yes" DiskId="1" Source="devel\bin\javac.exe"/>
                </Component>
                <Component Id="_41db84bc_9941_44a0_9c25_0a4af0881157" Guid="f6309bbe-e3ae-441a-885d-750a8f310444" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_6ff2d0c8_89f2_4aa0_84dd_29ccb07aa381" Name="javadoc.exe" KeyPath="yes" DiskId="1" Source="devel\bin\javadoc.exe"/>
                </Component>
                <Component Id="_6ce90a28_bde2_4d9d_b0b1_eb941add8c72" Guid="0cdf9102-7d90-44eb-b8fe-a2c5ff1e4e03" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_3aa4125f_f0bc_4894_8c65_15ffabd7384c" Name="javah.exe" KeyPath="yes" DiskId="1" Source="devel\bin\javah.exe"/>
                </Component>
                <Component Id="_19ba19f9_62cb_4a01_8e45_75eb9372a35a" Guid="da09faf6-dcb7-4932-8cbc-c32a81188b77" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_88ba3b28_4741_47f6_8fff_e1937a377579" Name="javap.exe" KeyPath="yes" DiskId="1" Source="devel\bin\javap.exe"/>
                </Component>
                <Component Id="_e2e10425_80f2_4308_b26c_c164da26cf48" Guid="5f2a8424-f922-4ae0-826a-ce5a70ca249c" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_5de2a592_ce50_4c61_8fc1_7d391795cfe8" Name="javaw.exe" KeyPath="yes" DiskId="1" Source="devel\bin\javaw.exe"/>
                </Component>
                <Component Id="_490552ac_dbd0_4e11_8f8c_bd9bb4460f80" Guid="f1709a79-eb23-43cd-a9f9-097937c5bfed" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_fb10ca7a_69c3_4320_952f_2e9ac32d1444" Name="jcmd.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jcmd.exe"/>
                </Component>
                <Component Id="_826df948_dbca_4629_a9a4_03ec46c227b2" Guid="20d8a2e2-52d5-4f67-90c5-7c8a83a77a27" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_11e09318_be90_419a_8f83_7cb2abd00718" Name="jconsole.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jconsole.exe"/>
                </Component>
                <Component Id="_173c6193_116f_4433_a48f_3cfa227f3462" Guid="fc42bbda-a20a-4a72-959e-78662b3b3de2" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_38112f5f_0b95_47d8_b7f0_902ed49bec03" Name="jdb.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jdb.exe"/>
                </Component>
                <Component Id="_91b77388_f032_490f_b210_cdd787eafceb" Guid="6e431c0d-802c-4633-9dac-703b5764924a" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_fcdd4aea_85a0_42ae_816b_ab399d6d6949" Name="jdeps.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jdeps.exe"/>
                </Component>
                <Component Id="_9e05ff7d_b74e_4229_b935_63f9f803ad2b" Guid="8660a336-3186-480e-b50e-a3854b52fda5" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_9a723d4f_52ea_49be_8460_df2f06213a91" Name="jhat.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jhat.exe"/>
                </Component>
                <Component Id="_28e965e0_f1d0_43dd_891f_bf1305208111" Guid="5c742dfb-33a0-419d-b164-ef004433cb30" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_f7633af4_53b4_49a0_8e6b_9f3096427a29" Name="jinfo.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jinfo.exe"/>
                </Component>
                <Component Id="_47692aed_f794_4447_9fd3_a1bc0a0c4650" Guid="5660408f-e829-448e-a44a-dcfb7d1988b8" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_bde2ebe4_c437_4d23_8661_7c8f12d7f32e" Name="jjs.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jjs.exe"/>
                </Component>
                <Component Id="_91c65a9b_dd17_42d5_9349_98bba1b71af2" Guid="27979362-5307-4354-a3ed-b1707aa23543" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_917541d5_66ac_462d_a9e2_387a70243fa1" Name="jli.dll" KeyPath="yes" DiskId="1" Source="devel\bin\jli.dll"/>
                </Component>
                <Component Id="_db61539e_ac98_42de_afca_c2e6e51db670" Guid="076018f0-0cd9-4a1f-907d-ef22668fa5d2" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_88ad968e_e0f5_4d3f_9235_93329d27f197" Name="jmap.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jmap.exe"/>
                </Component>
                <Component Id="_998c9383_c862_4dbd_9377_88a54d15de73" Guid="522e193d-b648-4823-bc5f-012af2767493" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_d95b8e60_bd11_4947_a6e0_00b2f56ce1ec" Name="jps.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jps.exe"/>
                </Component>
                <Component Id="_70067f92_c4eb_432d_8d41_0cd0a51ee1c8" Guid="526728b4-33d7-4369-ac7b-3e13160c63a4" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_acdd7db2_97a1_4c1e_a5d0_216fe8dd3df3" Name="jrunscript.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jrunscript.exe"/>
                </Component>
                <Component Id="_6c88c26a_4b61_4e60_b2c2_c203692c83ff" Guid="14ac0d38-cb06-4b2d-a280-4e5d57ece194" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_bcbc7a24_6160_4f67_a3f1_689f365e94f3" Name="jsadebugd.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jsadebugd.exe"/>
                </Component>
                <Component Id="_8299f795_18be_4f20_b4bb_b9a0e427965d" Guid="d221470a-da11-41d2-a6c1-1a121b0288a1" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_2ad41be5_e71c_43d1_b2a2_e3c5ff5af650" Name="jstack.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jstack.exe"/>
                </Component>
                <Component Id="_0ff4cc7d_0391_467c_8dc5_ef4ef92e4278" Guid="21a6c6e5-d38a-46dd-b7ed-340e14ee1cdf" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_3e05544a_8418_4b77_969f_00f15b9f7f96" Name="jstat.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jstat.exe"/>
                </Component>
                <Component Id="_da2a6f5b_ddb0_4c2f_8d07_cfd107c1043f" Guid="85cd8c6b-c531-4619-9da4-8f21b6e4acf9" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_4a72f38c_8a75_43c5_93bf_f1d151325f39" Name="jstatd.exe" KeyPath="yes" DiskId="1" Source="devel\bin\jstatd.exe"/>
                </Component>
                <Component Id="_43377a2a_4b5c_4eea_929d_9038b3792f88" Guid="67f46f9b-77d6-44e7-884b-f84653577bc0" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_eac7b14d_a1f9_4984_bb11_f73d54caf8d5" Name="keytool.exe" KeyPath="yes" DiskId="1" Source="devel\bin\keytool.exe"/>
                </Component>
                <Component Id="_bc2910ce_34b9_41bf_8784_707abc49a5a6" Guid="b292856d-f881-49b3-9c37-4574774e0283" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_0bf74b71_07ef_441e_b3bb_5d71bcce5982" Name="kinit.exe" KeyPath="yes" DiskId="1" Source="devel\bin\kinit.exe"/>
                </Component>
                <Component Id="_462cd018_317b_4928_8750_c8a094db56b4" Guid="ce2cdee0-7734-4e3a-9ef5-5d678ef2bbae" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_9f494d36_b06f_44a9_920a_c305df2a8202" Name="klist.exe" KeyPath="yes" DiskId="1" Source="devel\bin\klist.exe"/>
                </Component>
                <Component Id="_7b455994_59c1_45ec_9752_d0409c2a0a77" Guid="97d846df-5612-4960-9855-7a63da97f6f1" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_1013794f_0555_4ebd_aa72_00b167a4bea9" Name="ktab.exe" KeyPath="yes" DiskId="1" Source="devel\bin\ktab.exe"/>
                </Component>
                <Component Id="_639a6d3e_304c_437f_beaa_bf5716fd8515" Guid="d0437dea-c3ec-4588-9365-5b7d24441dae" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_5836ba9e_1597_473c_9dbe_10a431059730" Name="msvcr100.dll" KeyPath="yes" DiskId="1" Source="devel\bin\msvcr100.dll"/>
                </Component>
                <Component Id="_5d60ab91_96a8_4f4e_9502_2107a3e32f0c" Guid="885f4d88-28cf-474c-b868-fdb7d9b2ed58" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_93044e53_d7f0_4c53_8264_09967476d081" Name="native2ascii.exe" KeyPath="yes" DiskId="1" Source="devel\bin\native2ascii.exe"/>
                </Component>
                <Component Id="_e7365f9f_5c7a_4adc_9019_c4ff22cc2aff" Guid="ae044385-f24d-49ea-801d-41cdc7a358c3" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_b8fdfd45_ee73_46f5_99ef_6eb9a6f629ca" Name="ojdkbuild_giflib.dll" KeyPath="yes" DiskId="1" Source="devel\bin\ojdkbuild_giflib.dll"/>
                </Component>
                <Component Id="_a1deed3f_e165_493e_8963_1a65d0fcce63" Guid="23c0c341-acad-427d-8f32-a09aca5b19c4" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_ccf82aba_31f2_448e_b49e_1020e775b634" Name="ojdkbuild_libjpeg-turbo.dll" KeyPath="yes" DiskId="1" Source="devel\bin\ojdkbuild_libjpeg-turbo.dll"/>
                </Component>
                <Component Id="_f92e7590_b527_4f12_8a2a_7c49e6b13967" Guid="36fff01d-5dbf-4381-95df-ce99be5fb088" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_04f5955d_2584_42fc_9d51_d870105ebc01" Name="ojdkbuild_libpng.dll" KeyPath="yes" DiskId="1" Source="devel\bin\ojdkbuild_libpng.dll"/>
                </Component>
                <Component Id="_79037744_c2b3_4c1c_811d_b01a04bc42bf" Guid="f5027f74-155b-40ad-8b37-a10c017c1fee" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_5e1a1911_01a6_49e6_aee5_e6a5a0384743" Name="orbd.exe" KeyPath="yes" DiskId="1" Source="devel\bin\orbd.exe"/>
                </Component>
                <Component Id="_8718d24f_24ae_4293_b9db_8d69395a2199" Guid="00430874-285f-4a47-9f70-6d071a99448b" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_63c3f559_7494_4725_b3d6_29777c0ac6f2" Name="pack200.exe" KeyPath="yes" DiskId="1" Source="devel\bin\pack200.exe"/>
                </Component>
                <Component Id="_749007ef_9c3c_4508_a5b0_ff20a0f7d701" Guid="84eede5b-a10e-40b1-8af5-b2d43a9efdcf" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_27219c29_0e25_492f_9c3a_fb368f3948f1" Name="policytool.exe" KeyPath="yes" DiskId="1" Source="devel\bin\policytool.exe"/>
                </Component>
                <Component Id="_f7a9f075_b33f_4047_85e8_a531b3aff557" Guid="b66bdf88-e499-4336-9033-a34f364165f4" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_2d827cfc_fe99_47f6_8296_afafc5645851" Name="rmic.exe" KeyPath="yes" DiskId="1" Source="devel\bin\rmic.exe"/>
                </Component>
                <Component Id="_f85ec764_253b_4d8a_ad40_f690d02b2d3f" Guid="698fc6b1-bcc6-4786-afbd-32db260800d1" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_0673098d_a6c7_46f4_b8d0_d6e17352c97a" Name="rmid.exe" KeyPath="yes" DiskId="1" Source="devel\bin\rmid.exe"/>
                </Component>
                <Component Id="_105fbfe0_0dd3_4f68_b8e3_455e9890ae7e" Guid="97496960-d82a-4dcc-9eff-0611c7ed9cc3" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_e6b16fcc_be9a_41fb_a0ff_7b93677ed0e9" Name="rmiregistry.exe" KeyPath="yes" DiskId="1" Source="devel\bin\rmiregistry.exe"/>
                </Component>
                <Component Id="_783a6e81_903d_486f_9fc9_b406dd680e46" Guid="e5dbbfa2-4046-41ca-a53e-1345e5caa28b" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_d12ee6de_051e_4b5e_8cb0_fc37effe0069" Name="schemagen.exe" KeyPath="yes" DiskId="1" Source="devel\bin\schemagen.exe"/>
                </Component>
                <Component Id="_0b14c485_3ab2_407c_8ba6_a64a1eb3039d" Guid="cf447e06-c570-492b-adb2-72015590ab15" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_47dcf880_6b8d_4e74_a234_30d35a38b1be" Name="serialver.exe" KeyPath="yes" DiskId="1" Source="devel\bin\serialver.exe"/>
                </Component>
                <Component Id="_3dce4259_41d5_4719_964d_95a96f149a95" Guid="397649ff-327d-4458-847f-782ff1859b3c" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_c750fb72_e7e4_46dc_861d_78f89c66d1e7" Name="servertool.exe" KeyPath="yes" DiskId="1" Source="devel\bin\servertool.exe"/>
                </Component>
                <Component Id="_35752ec5_c8f3_4d90_a9cc_748ac0b27cb3" Guid="b8d40e4b-3a55-4366-b2df-0fb212e5c924" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_ec911649_1268_465f_9240_f37423ffca38" Name="tnameserv.exe" KeyPath="yes" DiskId="1" Source="devel\bin\tnameserv.exe"/>
                </Component>
                <Component Id="_85d2897a_3f38_42ec_9fbe_8250ea672488" Guid="447ec612-1d8f-4b06-8f42-7f3d10137891" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_681cb970_71b3_4c34_ba0a_3a477113b845" Name="unpack200.exe" KeyPath="yes" DiskId="1" Source="devel\bin\unpack200.exe"/>
                </Component>
                <Component Id="_1b53ab83_f99b_4c5b_ad19_6921ee98e8ba" Guid="eefbdfc5-2495-4581-a304-4183f090e95b" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_b45cd28d_4ed5_404e_a7fa_ee9085b674db" Name="wsgen.exe" KeyPath="yes" DiskId="1" Source="devel\bin\wsgen.exe"/>
                </Component>
                <Component Id="_c27c8919_8dad_457a_b348_8b31ea622fc1" Guid="121a4cef-c8e7-4cac-88b3-62cee6f1d41f" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_1c938785_aba1_4d25_8796_a6e4db876f2d" Name="wsimport.exe" KeyPath="yes" DiskId="1" Source="devel\bin\wsimport.exe"/>
                </Component>
                <Component Id="_7b8ff6d2_9fd3_43ef_bd16_24c81723d866" Guid="4c68e67c-99d7-4862-9158-0c6c5e5d1a84" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_a8a10036_ce6f_466f_8e9f_78ed2f0acec9" Name="xjc.exe" KeyPath="yes" DiskId="1" Source="devel\bin\xjc.exe"/>
                </Component>
            </Directory>
            <Directory Id="_94b025fc_ff53_4fa5_a9c7_312cddd5c4c4" Name="include">
                <Component Id="_c8b645a9_c3a6_4d58_bbf1_e3ed6de876e4" Guid="fc4e8902-ffd5-4d7e-9e61-8602563f4e5a" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_77063add_ab18_4bef_99f1_3f72a7a84468" Name="classfile_constants.h" KeyPath="yes" DiskId="1" Source="devel\include\classfile_constants.h"/>
                </Component>
                <Component Id="_b8e54899_7da5_4274_978e_b6e488207ab3" Guid="f8833968-320b-4e36-a50e-5e3ab6370ae0" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_67cec329_7e3a_4064_88ee_831132110fc3" Name="jawt.h" KeyPath="yes" DiskId="1" Source="devel\include\jawt.h"/>
                </Component>
                <Component Id="_4140e747_a614_4526_99ab_e85c8d90393b" Guid="c1fe9d70-d773-470c-98f8-76053ec194c7" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_7422d3da_4ed8_4ffa_bf52_8bdfa2ce5a5e" Name="jdwpTransport.h" KeyPath="yes" DiskId="1" Source="devel\include\jdwpTransport.h"/>
                </Component>
                <Component Id="_7667d0af_5d8a_4a5a_9ee5_270a7547a003" Guid="b1c90695-fb1e-4b90-8d71-68bab7671a90" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_e0949813_56f9_4cc2_ba61_ec511f65b0f7" Name="jni.h" KeyPath="yes" DiskId="1" Source="devel\include\jni.h"/>
                </Component>
                <Component Id="_902ad54a_7609_479e_9056_a944a7766a45" Guid="45a444d8-eb32-46f5-a92b-82ef5bac96ee" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_037a2ab2_99ed_43ae_82a8_32e0e0dd35bb" Name="jvmti.h" KeyPath="yes" DiskId="1" Source="devel\include\jvmti.h"/>
                </Component>
                <Component Id="_11b90242_32f2_4f24_a8d1_7c18dbdc4256" Guid="f533a3c9-a5df-486f-b0b1-d2dbbd968fcd" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_7029802c_3faa_4b9f_b0e5_2bf89d6c859f" Name="jvmticmlr.h" KeyPath="yes" DiskId="1" Source="devel\include\jvmticmlr.h"/>
                </Component>
                <Directory Id="_ab0f193d_5e1a_4d8f_b08f_e708a96d4594" Name="win32">
                    <Directory Id="_512f81ed_06aa_4953_a5ad_b6deec5d37db" Name="bridge">
                        <Component Id="_b0eb8a7d_c30f_4767_af39_fdaaf665103e" Guid="bca5d152-8f8e-4cec-9f20-f2e3b3af1f71" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                            <File Id="_15af3d6e_104f_4d4a_994d_2ddc07b0320a" Name="AccessBridgeCallbacks.h" KeyPath="yes" DiskId="1" Source="devel\include\win32\bridge\AccessBridgeCallbacks.h"/>
                        </Component>
                        <Component Id="_d8c10340_4277_4536_b210_4b8b86e83dbc" Guid="04d3fe13-d562-473f-b155-299eda07e476" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                            <File Id="_557dda3c_e08b_45dc_bd06_aa6c0afdc863" Name="AccessBridgeCalls.c" KeyPath="yes" DiskId="1" Source="devel\include\win32\bridge\AccessBridgeCalls.c"/>
                        </Component>
                        <Component Id="_890da443_cab9_4d10_aab4_518f595cfbae" Guid="fdb89de7-41a7-4545-ba01-b281caac91df" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                            <File Id="_784ea6e1_9e1f_45fb_b279_7a8c40bcfd5e" Name="AccessBridgeCalls.h" KeyPath="yes" DiskId="1" Source="devel\include\win32\bridge\AccessBridgeCalls.h"/>
                        </Component>
                        <Component Id="_21a6c7f6_22de_4a2a_ab44_9a9022e47250" Guid="8a2295a3-c652-4ff7-8199-7260bb54240e" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                            <File Id="_733ebcd6_6e78_44be_843c_be294d494899" Name="AccessBridgePackages.h" KeyPath="yes" DiskId="1" Source="devel\include\win32\bridge\AccessBridgePackages.h"/>
                        </Component>
                    </Directory>
                    <Component Id="_cb239b2b_28df_479f_941b_594cf452f6f9" Guid="5022b753-1b74-4bea-9a14-044ca449ccaf" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                        <File Id="_6fa36d39_4d45_4d35_b17d_81c09073ba51" Name="jawt_md.h" KeyPath="yes" DiskId="1" Source="devel\include\win32\jawt_md.h"/>
                    </Component>
                    <Component Id="_de8665a9_945f_4e3f_b421_c2e199f5c309" Guid="c91bceb4-0491-4375-9a7a-b8bb09d625ce" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                        <File Id="_ce9e9965_4194_4a9a_8e8f_26f1a5248166" Name="jni_md.h" KeyPath="yes" DiskId="1" Source="devel\include\win32\jni_md.h"/>
                    </Component>
                </Directory>
            </Directory>
            <Directory Id="_4e737567_15c7_4bcb_95a1_7bcd33e735cd" Name="lib">
                <Component Id="_a21682eb_78ec_4438_9829_c8bd84506c92" Guid="9a9dc6a8-20fd-4016-9bc1-2911839c4c92" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_f8636576_5b38_45d4_87d4_f826426483be" Name="ct.sym" KeyPath="yes" DiskId="1" Source="devel\lib\ct.sym"/>
                </Component>
                <Component Id="_850ea62a_1bae_465b_a5f5_74753f16aab3" Guid="bb31b4e7-1ddf-423d-bbf5-9c3ffe8f7e77" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_a24189a9_bf47_4d0e_a1af_a5d58d6acbcb" Name="dt.jar" KeyPath="yes" DiskId="1" Source="devel\lib\dt.jar"/>
                </Component>
                <Component Id="_8001dcaa_9eb4_4a23_9cbb_402f8ea2fda2" Guid="c23ef9ab-2797-4699-8233-76ab782770c4" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_2046b4aa_b432_4c82_99ec_d0e28fbd1271" Name="ir.idl" KeyPath="yes" DiskId="1" Source="devel\lib\ir.idl"/>
                </Component>
                <Component Id="_04c9598f_b898_48c8_b1ff_80e3efb7c0d6" Guid="ad6dd07d-9791-4c9b-881d-f3c455f0001c" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_f36a428b_4c4e_4462_a7ae_56cd06f6bb07" Name="jawt.lib" KeyPath="yes" DiskId="1" Source="devel\lib\jawt.lib"/>
                </Component>
                <Component Id="_9f973fc3_d107_41fd_8d91_a5704edc5de1" Guid="02717f07-c8e2-42a2-bfa8-07266d20ad43" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_722a43eb_56a3_4279_989b_d9f58fb736d0" Name="jconsole.jar" KeyPath="yes" DiskId="1" Source="devel\lib\jconsole.jar"/>
                </Component>
                <Component Id="_cb36904a_4324_4d59_b3be_58fc581f0e5f" Guid="90facd7f-e033-4d19-a42f-2bd560d9322d" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_08a283c4_502e_4d2f_aa2a_da986b991c54" Name="jvm.lib" KeyPath="yes" DiskId="1" Source="devel\lib\jvm.lib"/>
                </Component>
                <Component Id="_b742d1ae_40ec_47d3_8a20_7b1de9e34f1f" Guid="cb931e61-b169-4dfc-9cc3-79e162e2d9fa" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_279e414f_406e_4eea_b0bc_2075bb57584e" Name="orb.idl" KeyPath="yes" DiskId="1" Source="devel\lib\orb.idl"/>
                </Component>
                <Component Id="_d7236023_bd3c_4e43_992e_b1553fee648d" Guid="c00cbd6a-a2a0-421c-928d-9c7a8ff70134" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_b5c78cd7_7ba4_4106_8428_cbb8a22bf153" Name="sa-jdi.jar" KeyPath="yes" DiskId="1" Source="devel\lib\sa-jdi.jar"/>
                </Component>
                <Component Id="_11842f34_bb3f_47e8_a30f_e6f432bc59d9" Guid="32065419-e2f0-477e-9df1-2e04ec8f5b75" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                    <File Id="_40913438_f27c_4ad6_ae10_2666b11554de" Name="tools.jar" KeyPath="yes" DiskId="1" Source="devel\lib\tools.jar"/>
                </Component>
            </Directory>
            <Component Id="_988fb201_d155_4c2e_841c_81d341059f17" Guid="52f87f3f-44fa-473e-b706-49cefc59b069" Win64="${${PROJECT_NAME}_INSTALLER_WIN64_WIX}">
                <File Id="_93425f99_e147_4007_b264_288ec509d5d3" Name="src.zip" KeyPath="yes" DiskId="1" Source="devel\src.zip"/>
            </Component>
        </Directory>

    </xsl:template>
    <xsl:template match="w:Feature[@ConfigurableDirectory='INSTALLDIR']">
        <Feature Id="jdk" xmlns="http://schemas.microsoft.com/wix/2006/wi">
            <xsl:apply-templates select="@* | *"/>
            <Feature Id="jdk_devel" Absent="allow" AllowAdvertise="no" Level="${${PROJECT_NAME}_INSTALLER_FEATURE_LEVEL}"
                     Title="Development Kit"
                     Description="OpenJDK development files."
                     xmlns="http://schemas.microsoft.com/wix/2006/wi">
                <ComponentRef Id="_1fdc4efc_b5e9_46fb_8fd9_6903e19527af"/>
                <ComponentRef Id="_ef0a35df_ddee_45cc_8f37_a01f6e8f322d"/>
                <ComponentRef Id="_2d92ecc9_2f6c_4fd3_b57b_f43b2666a239"/>
                <ComponentRef Id="_0d79ab43_5163_499d_9f65_8e61ac075768"/>
                <ComponentRef Id="_700a0975_27d0_4328_9700_dc6c38262c86"/>
                <ComponentRef Id="_9dec4207_be6f_4e44_a179_3229ca9ff1e0"/>
                <ComponentRef Id="_30886f4f_2720_470e_9758_bbc675bda322"/>
                <ComponentRef Id="_a51ec78e_1ab2_4c3c_bbde_7054faf87787"/>
                <ComponentRef Id="_f681e57c_3221_4f4e_9f8e_bdf659730819"/>
                <ComponentRef Id="_d5bf739a_d61e_4991_81e0_f48c6579535f"/>
                <ComponentRef Id="_40704ef5_7acf_4d57_aa97_558ca216ea3a"/>
                <ComponentRef Id="_41db84bc_9941_44a0_9c25_0a4af0881157"/>
                <ComponentRef Id="_6ce90a28_bde2_4d9d_b0b1_eb941add8c72"/>
                <ComponentRef Id="_19ba19f9_62cb_4a01_8e45_75eb9372a35a"/>
                <ComponentRef Id="_e2e10425_80f2_4308_b26c_c164da26cf48"/>
                <ComponentRef Id="_490552ac_dbd0_4e11_8f8c_bd9bb4460f80"/>
                <ComponentRef Id="_826df948_dbca_4629_a9a4_03ec46c227b2"/>
                <ComponentRef Id="_173c6193_116f_4433_a48f_3cfa227f3462"/>
                <ComponentRef Id="_91b77388_f032_490f_b210_cdd787eafceb"/>
                <ComponentRef Id="_9e05ff7d_b74e_4229_b935_63f9f803ad2b"/>
                <ComponentRef Id="_28e965e0_f1d0_43dd_891f_bf1305208111"/>
                <ComponentRef Id="_47692aed_f794_4447_9fd3_a1bc0a0c4650"/>
                <ComponentRef Id="_91c65a9b_dd17_42d5_9349_98bba1b71af2"/>
                <ComponentRef Id="_db61539e_ac98_42de_afca_c2e6e51db670"/>
                <ComponentRef Id="_998c9383_c862_4dbd_9377_88a54d15de73"/>
                <ComponentRef Id="_70067f92_c4eb_432d_8d41_0cd0a51ee1c8"/>
                <ComponentRef Id="_6c88c26a_4b61_4e60_b2c2_c203692c83ff"/>
                <ComponentRef Id="_8299f795_18be_4f20_b4bb_b9a0e427965d"/>
                <ComponentRef Id="_0ff4cc7d_0391_467c_8dc5_ef4ef92e4278"/>
                <ComponentRef Id="_da2a6f5b_ddb0_4c2f_8d07_cfd107c1043f"/>
                <ComponentRef Id="_43377a2a_4b5c_4eea_929d_9038b3792f88"/>
                <ComponentRef Id="_bc2910ce_34b9_41bf_8784_707abc49a5a6"/>
                <ComponentRef Id="_462cd018_317b_4928_8750_c8a094db56b4"/>
                <ComponentRef Id="_7b455994_59c1_45ec_9752_d0409c2a0a77"/>
                <ComponentRef Id="_639a6d3e_304c_437f_beaa_bf5716fd8515"/>
                <ComponentRef Id="_5d60ab91_96a8_4f4e_9502_2107a3e32f0c"/>
                <ComponentRef Id="_e7365f9f_5c7a_4adc_9019_c4ff22cc2aff"/>
                <ComponentRef Id="_a1deed3f_e165_493e_8963_1a65d0fcce63"/>
                <ComponentRef Id="_f92e7590_b527_4f12_8a2a_7c49e6b13967"/>
                <ComponentRef Id="_79037744_c2b3_4c1c_811d_b01a04bc42bf"/>
                <ComponentRef Id="_8718d24f_24ae_4293_b9db_8d69395a2199"/>
                <ComponentRef Id="_749007ef_9c3c_4508_a5b0_ff20a0f7d701"/>
                <ComponentRef Id="_f7a9f075_b33f_4047_85e8_a531b3aff557"/>
                <ComponentRef Id="_f85ec764_253b_4d8a_ad40_f690d02b2d3f"/>
                <ComponentRef Id="_105fbfe0_0dd3_4f68_b8e3_455e9890ae7e"/>
                <ComponentRef Id="_783a6e81_903d_486f_9fc9_b406dd680e46"/>
                <ComponentRef Id="_0b14c485_3ab2_407c_8ba6_a64a1eb3039d"/>
                <ComponentRef Id="_3dce4259_41d5_4719_964d_95a96f149a95"/>
                <ComponentRef Id="_35752ec5_c8f3_4d90_a9cc_748ac0b27cb3"/>
                <ComponentRef Id="_85d2897a_3f38_42ec_9fbe_8250ea672488"/>
                <ComponentRef Id="_1b53ab83_f99b_4c5b_ad19_6921ee98e8ba"/>
                <ComponentRef Id="_c27c8919_8dad_457a_b348_8b31ea622fc1"/>
                <ComponentRef Id="_7b8ff6d2_9fd3_43ef_bd16_24c81723d866"/>
                <ComponentRef Id="_c8b645a9_c3a6_4d58_bbf1_e3ed6de876e4"/>
                <ComponentRef Id="_b8e54899_7da5_4274_978e_b6e488207ab3"/>
                <ComponentRef Id="_4140e747_a614_4526_99ab_e85c8d90393b"/>
                <ComponentRef Id="_7667d0af_5d8a_4a5a_9ee5_270a7547a003"/>
                <ComponentRef Id="_902ad54a_7609_479e_9056_a944a7766a45"/>
                <ComponentRef Id="_11b90242_32f2_4f24_a8d1_7c18dbdc4256"/>
                <ComponentRef Id="_b0eb8a7d_c30f_4767_af39_fdaaf665103e"/>
                <ComponentRef Id="_d8c10340_4277_4536_b210_4b8b86e83dbc"/>
                <ComponentRef Id="_890da443_cab9_4d10_aab4_518f595cfbae"/>
                <ComponentRef Id="_21a6c7f6_22de_4a2a_ab44_9a9022e47250"/>
                <ComponentRef Id="_cb239b2b_28df_479f_941b_594cf452f6f9"/>
                <ComponentRef Id="_de8665a9_945f_4e3f_b421_c2e199f5c309"/>
                <ComponentRef Id="_a21682eb_78ec_4438_9829_c8bd84506c92"/>
                <ComponentRef Id="_850ea62a_1bae_465b_a5f5_74753f16aab3"/>
                <ComponentRef Id="_8001dcaa_9eb4_4a23_9cbb_402f8ea2fda2"/>
                <ComponentRef Id="_04c9598f_b898_48c8_b1ff_80e3efb7c0d6"/>
                <ComponentRef Id="_9f973fc3_d107_41fd_8d91_a5704edc5de1"/>
                <ComponentRef Id="_cb36904a_4324_4d59_b3be_58fc581f0e5f"/>
                <ComponentRef Id="_b742d1ae_40ec_47d3_8a20_7b1de9e34f1f"/>
                <ComponentRef Id="_d7236023_bd3c_4e43_992e_b1553fee648d"/>
                <ComponentRef Id="_11842f34_bb3f_47e8_a30f_e6f432bc59d9"/>
                <ComponentRef Id="_988fb201_d155_4c2e_841c_81d341059f17"/>
            </Feature>
        </Feature>
    </xsl:template>
</xsl:stylesheet>

