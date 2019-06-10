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
var ZipOutputStream = Packages.java.util.zip.ZipOutputStream;

function copy(is, os) {
    var buf = Array.newInstance(Byte.TYPE, 4096);
    var read = -1;
    while (-1 !== (read = is.read(buf, 0, buf.length))) {
        os.write(buf, 0, read);
    }
}

function listDirectory(root, dir) {
    var iter = files.newDirectoryStream(dir);
    var list = [];
    for each (pa in iter) {
        list.push(root.relativize(pa.toAbsolutePath()));
    }
    iter.close();
    list.sort(function(a, b) {
        if (files.isDirectory(a) && !files.isDirectory(b)) {
            return -1;
        }
        if (!files.isDirectory(a) && files.isDirectory(b)) {
            return 1;
        }
        return a.compareTo(b);
    });
    return list;
}

function walkAndZip(root, zos, dir) {
    zos.putNextEntry(new ZipEntry(dir.toString().replace(/\\/g, "/") + "/"));
    zos.closeEntry();
    var dirname = dir.getFileName().toString();
    var list = listDirectory(root, dir);
    for each (pa in list) {
        if (files.isDirectory(pa)) {
            walkAndZip(root, zos, pa);
        } else {
            zos.putNextEntry(new ZipEntry(pa.toString().replace(/\\/g, "/")));
            var is = files.newInputStream(pa, StandardOpenOption.READ);
            try {
                copy(is, zos);
            } finally {
                is.close();
            }
            zos.closeEntry();    
        }
    }
}

if (2 !== arguments.length && 3 !== arguments.length) {
    print("ERROR: invalid arguments specified, count: [" + arguments.length + "]");
    print("USAGE: jrunscript zip.js <compression_level> <path_to_directory> [dest_file_name]");
    exit(1);
}

var level = parseInt(arguments[0]);
if (!(level >= 0) && (level <= 9)) {
    print("ERROR: invalid compression level specified, value: [" + arguments[0] + "]");
    exit(1);
}
var dir = paths.get(arguments[1]);
if (!files.isDirectory(dir)) {
    print("ERROR: invalid directory specified, path: [" + dir.toAbsolutePath().toString() + "]");
    exit(1);
}
var dest = "";
if (2 === arguments.length) {
    dest = paths.get(dir.toString() + ".zip");
} else {
    dest = paths.get(arguments[2]);
}
if (files.exists(dest)) {
    print("ERROR: destination file already exists, path: [" + dest.toAbsolutePath().toString() + "]");
    exit(1);
}

print(dest.getFileName().toString());
var root = dir.toAbsolutePath().getParent();
var os = files.newOutputStream(dest, StandardOpenOption.CREATE_NEW, StandardOpenOption.WRITE);
try {
    var zos = new ZipOutputStream(os, utf8);
    zos.setLevel(level);
    walkAndZip(root, zos, dir);
    zos.close();
} finally {
    os.close();
}

