#!/bin/bash

# Author: mash mash@hyc.cn
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

basedir=${PWD##*/}
printf 'current dir %s\n' "${PWD##*/}"

yum install -y rpms/netaddr.rpm

yum install -y rpms/ansible.rpm

yum install -y rpms/docker.rpm

docker load < containers/registry.tar

docker run -d -p 5000:5000 -v registry:/var/lib/registry --name registry registry:2

