# Copyright 2017, akashche at redhat.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required ( VERSION 2.8.12 )

set ( ${PROJECT_NAME}_MILESTONE "ojdkbuild" CACHE STRING "Version string 'milestone' field" )
set ( ${PROJECT_NAME}_MAJOR_VERSION "9" CACHE STRING "Major version number" )
set ( ${PROJECT_NAME}_UPDATE "4" CACHE STRING "Version string 'update' field" )
set ( ${PROJECT_NAME}_BUILD "11" CACHE STRING "Version string 'build' field" )
set ( ${PROJECT_NAME}_RPMBUILD "1" CACHE STRING "Build number in image name" )
