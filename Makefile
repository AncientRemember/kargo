
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

# ��һ��: make download ���ػ�����װ����docker����,���ص��ļ�����denpendencies
# �ڶ���: tar -zcf kargo.tar.gz kargo ������߰�װ��
# ������: �����߰�װ�����Ƶ�Ŀ������
# ���Ĳ�: �༭inventory/hosts �ο�inventory.example�������vagrant���Կ�������
# ���岽: make installbase ��װansible��docker
# ������: make deploy,�����vagrant���� make vagrant

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