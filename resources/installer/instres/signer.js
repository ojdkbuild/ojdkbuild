#!/usr/lib/jvm/java-1.8.0/bin/jjs

var arrays = Packages.java.util.Arrays;
var files = Packages.java.nio.file.Files;
var paths = Packages.java.nio.file.Paths;
var system = Packages.java.lang.System;
var ProcessBuilder = Packages.java.lang.ProcessBuilder;

if (1 != arguments.length) {
    print("Error: invalid arguments");
    print("Usage: jjs signer.js path/to/app/dir");
    system.exit(1);
}

function walkAndSign(dirpath) {
    var st = files.newDirectoryStream(dirpath);
    for each (pa in st) {
        var name = pa.getFileName().toString();
        if (files.isDirectory(pa)) {
            walkAndSign(pa);
        } else if(files.isRegularFile(pa) &&
                    (name.endsWith(".exe") || name.endsWith(".dll")) &&
                    !(name.startsWith("msvc") || name.startsWith("api-ms-win"))) {
            print("Signing: [" + name + "]");
            // no-op by default, vendor signing may be added below
        }
    }
    st.close();
}

walkAndSign(paths.get(arguments[0]));
