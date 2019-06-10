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

var JArray = Packages.java.lang.reflect.Array;
var Byte = Packages.java.lang.Byte;
var StringBuilder = Packages.java.lang.StringBuilder;
var files = Packages.java.nio.file.Files;
var paths = Packages.java.nio.file.Paths;
var StandardOpenOption = Packages.java.nio.file.StandardOpenOption;
var utf8 = Packages.java.nio.charset.StandardCharsets.UTF_8;
var MessageDigest = Packages.java.security.MessageDigest;

var HEX_CHARS = "0123456789abcdef";

if (1 != arguments.length) {
    print("ERROR: specify a path to file as a first and only argument," +
            " arguments specified: [" + arguments.length + "]");
    exit(1);
}
var filename = arguments[0];
var path = paths.get(filename);
if (!files.exists(path)) {
    print("ERROR: input file doesn't exist: [" + filename + "]");
    exit(1);
}

var buf = JArray.newInstance(Byte.TYPE, 4096);
var md = MessageDigest.getInstance("SHA-256");
var is = files.newInputStream(path, StandardOpenOption.READ);
try {
    while (-1 != (read = is.read(buf))) {
        md.update(buf, 0, read);
    }
} finally {
    is.close();
}
var bytes = md.digest();
var sb = new StringBuilder(bytes.length * 2);
for (var i = 0; i < bytes.length; i++) {
    sb.append(HEX_CHARS[(bytes[i] >> 4) & 0xF]);
    sb.append(HEX_CHARS[(bytes[i] & 0xF)]);
}
var sha256 = sb.toString() + "  " + path.getFileName().toString();
var dest = paths.get(path.toAbsolutePath().getParent().toString(), path.getFileName().toString() + ".sha256");
files.write(dest, sha256.getBytes(utf8));
