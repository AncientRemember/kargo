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

rpmdir="$(basedir)/rpm"
if [ ! -d "$rpmdir"]; then  
　　mkdir "$rpmdir"  
fi

if [ ! -d "$rpmdir/"]; then  
　　mkdir "$rpmdir"
fi 
wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/docker-1.12.6-11.el7.centos.x86_64.rpm -o rpm/docker.rpm

wget http://dl.fedoraproject.org/pub/epel/7/x86_64/a/ansible-2.2.1.0-1.el7.noarch.rpm -o rpm/ansible.rpm

docker pull registry:2

docker save -o registry.tar registry:2

