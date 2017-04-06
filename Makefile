
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

# ��������
# ��1��: make common,��������,��װ������
# ��2��: make package ���ػ�����װ����docker����,���ص��ļ�����denpendencies

# ����
# make test

# ��3��: �����߰�װ�����Ƶ�Ŀ������

# ����Ŀ�껷��
# ��4��: �༭inventory/hosts �ο�inventory.example�������vagrant���Կ�������
# ��5��: make prepare ��װansible��docker
# ��6��: make deploy,�����vagrant���� make test



.PHONY:	setup package prepare deploy test

common:
	yum -y update
	yum -y install epel-release
	yum -y install python python-pip ansible docker
	pip install --upgrade pip
	pip install docker-py
	pip install --upgrade Jinja2
	pip install netaddr
	systemctl enable docker
	systemctl start docker
prepare: common
	docker load < ./dependencies/containers/registry2.tar
	$(shell docker run -d -p 5000:5000 -v $(pwd)/dependencies/registry:/var/lib/registry --name registry registry:2)
deploy: 
	ansible-playbook cluster.yml -i ./inventory/hosts
package: 
	ansible-playbook prepareoffline.yml -i ./inventory/local-tests.cfg
	tar --exclude='./.vagrant' -zcf ../kargo.tar.gz .
test:
ifneq ($(shell yum list installed | grep dkms|wc -l),1)
	yum install -y dkms
endif
ifneq ($(shell yum list installed | grep ruby|wc -l),1)
	yum install -y ruby
endif
ifneq ($(shell yum list installed | grep vagrant|wc -l),1)
	wget https://releases.hashicorp.com/vagrant/1.9.3/vagrant_1.9.3_x86_64.rpm?_ga=1.264649551.1710466342.1490161207 -o vagrant_1.9.3_x86_64.rpm
	yum install vagrant_1.9.3_x86_64.rpm
endif
ifneq ($(shell yum list installed | grep VirtualBox|wc -l),1)
	wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo -o /etc/yum.repos.d/virtualbox.repo 
	yum install -y VirtualBox-5.1.x86_64
endif
	vagrant up --no-provision
	vagrant provision