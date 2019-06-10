/*
 * Copyright 2019, akashche at redhat.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

var Array = Packages.java.lang.reflect.Array;
var Byte = Packages.java.lang.Byte;
var utf8 = Packages.java.nio.charset.StandardCharsets.UTF_8;
var files = Packages.java.nio.file.Files;
var paths = Packages.java.nio.file.Paths;
var StandardOpenOption = Packages.java.nio.file.StandardOpenOption;
var ZipEntry = Packages.java.util.zip.ZipEntry;
var ZipInputStream = Packages.java.util.zip.ZipInputStream;

function copy(is, os) {
    var buf = Array.newInstance(Byte.TYPE, 4096);
    var read = -1;
    while (-1 !== (read = is.read(buf, 0, buf.length))) {
        os.write(buf, 0, read);
    }
}

function writeFile(path, is) {
    var os = files.newOutputStream(path, StandardOpenOption.CREATE_NEW, StandardOpenOption.WRITE);
    try {
        copy(is, os);
    } finally {
        os.close();
    }
}

if (1 != arguments.length) {
    print("ERROR: invalid arguments specified, count: [" + arguments.length + "]");
    print("USAGE: jrunscript unzip.js <path_to_zip_file>");
    exit(1);
}

var zipFile = paths.get(arguments[0]);
if (!files.isRegularFile(zipFile)) {
    print("ERROR: invalid input file specified, path: [" + dir.toAbsolutePath().toString() + "]");
    exit(1);
}

var is = files.newInputStream(zipFile, StandardOpenOption.READ);
try {
    var zis = new ZipInputStream(is, utf8);
    var entry = null;
    while(null !== (entry = zis.getNextEntry())) {
        var path = paths.get(entry.getName());
        if (path.isAbsolute() || files.exists(path)) {
            print("ERROR: invalid ZIP entry, path: [" + entry.getName() + "]");
            exit(1);
        }
        if (entry.isDirectory()) {
            files.createDirectories(path);
        } else {
           writeFile(path, zis);
        }
        zis.closeEntry();
    }
    zis.close();
} finally {
    is.close();
}
