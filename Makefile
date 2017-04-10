
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

# 构建环境
# 第1步: make common,如果是裸机,安装基本包
# 第2步: make package 下载基础安装包及docker镜像,下载的文件存在denpendencies

# 测试
# make test

# 第3步: 将离线安装包复制到目标主机

# 部署目标环境
# 第4步: 编辑inventory/hosts 参考inventory.example，如果是vagrant测试可以跳过
# 第5步: make prepare 安装ansible和docker
# 第6步: make deploy,如果是vagrant测试 make test




.PHONY:	setup package prepare deploy test

common:
	yum -y update
	yum -y install epel-release
	yum -y install python python-pip ansible docker
	pip install --upgrade pip
	pip install docker-py
	pip install --upgrade Jinja2
	pip install netaddr
	setenforce 0
	systemctl enable docker
	systemctl start docker
prepare: common
	docker load < ./dependencies/containers/registry2.tar
	$(shell docker run -d -p 5000:5000 -v $(pwd)/dependencies/registry:/var/lib/registry --name registry registry:2)
deploy: 
ifdef tags
	ansible-playbook cluster.yml -i ./inventory/hosts --tags="$(tags)"
else ifdef skiptags
	ansible-playbook cluster.yml -i ./inventory/hosts --skip-tags="$(tags)"
else
	ansible-playbook cluster.yml -i ./inventory/hosts
endif

	
package: 
	ansible-playbook prepareoffline.yml -i ./inventory/local-tests.cfg
	tar --exclude='./.vagrant' -zcf ../kargo.tar.gz .
test:
ifeq ($(shell yum list installed | grep dkms|wc -l),0)
	yum install -y dkms
endif
ifeq ($(shell yum list installed | grep ruby|wc -l),0)
	yum install -y ruby
endif
ifeq ($(shell yum list installed | grep vagrant|wc -l),0)
	wget https://releases.hashicorp.com/vagrant/1.9.3/vagrant_1.9.3_x86_64.rpm
	yum install -y vagrant_1.9.3_x86_64.rpm
endif
ifeq ($(shell yum list installed | grep VirtualBox|wc -l),0)
	wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo -O /etc/yum.repos.d/virtualbox.repo
	yum install -y VirtualBox-5.1.x86_64
endif
ifdef upvm
	vagrant up --no-provision
endif
ifdef upvmonly
	vagrant up --no-provision	
else
	vagrant provision
endif