
# Copyright 2016 The Kubernetes Authors.
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

# 第一步: make download 下载基础安装包及docker镜像,下载的文件存在denpendencies
# 第二步: tar -zcf kargo.tar.gz kargo 打成离线安装包
# 第三步: 将离线安装包复制到目标主机
# 第四步: 编辑inventory/hosts 参考inventory.example，如果是vagrant测试可以跳过
# 第五步: make installbase 安装ansible和docker
# 第六步: make deploy,如果是vagrant测试 make vagrant

.PHONY:	download installbase deploy vagrant

TAG = v4.6.1-1
PREFIX = gcr.io/google_containers

installbase:
	yum -y install  ./dependencies/rpms/netaddr.rpm
	yum -y install  ansible
	yum -y install  ./dependencies/rpms/docker.rpm
	docker load < ./dependencies/containers/registry.tar
	docker run -d -p 5000:5000 -v registry:/var/lib/registry --name registry registry:2
deploy:
	ansible-playbook -i ./inventory/hosts
download: 
	ansible-playbook -i ./inventory/local-tests.cfg
vagrant:
	vagrant up