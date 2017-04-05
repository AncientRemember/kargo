
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

# 第一步: make achive 下载基础安装包及docker镜像,下载的文件存在denpendencies
# 第三步: 将离线安装包复制到目标主机
# 第四步: 编辑inventory/hosts 参考inventory.example，如果是vagrant测试可以跳过
# 第五步: make prepare 安装ansible和docker
# 第六步: make deploy,如果是vagrant测试 make test

.PHONY:	achive prepare deploy test

prepare:
	yum -y update
	yum -y install epel-release
	yum -y install python python-pip ansible docker
	pip install --upgrade pip
	pip install docker-py
	systemctl enable docker
	systemctl start docker
	docker load < ./dependencies/containers/registry2.tar
	docker run -d -p 5000:5000 -v registry:/var/lib/registry --name registry registry:2
deploy:
	ansible-playbook cluster.yml -i ./inventory/hosts
achive: 
	ansible-playbook prepareoffline.yml -i ./inventory/local-tests.cfg
	tar -zcf kargo.tar.gz .
test:
ifneq ($(shell yum list installed | grep dkms|wc -l),1)
	yum install -y dkms
endif
ifneq ($(shell yum list installed | grep VirtualBox|wc -l),1)
	wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo -o /etc/yum.repos.d/virtualbox.repo 
	yum install -y VirtualBox-5.1.x86_64
endif
	vagrant up --no-provision
	vagrant provision