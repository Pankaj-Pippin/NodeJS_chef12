#
# Author:: Marius Ducea (marius@promethost.com)
# Cookbook Name:: nodejs
# Recipe:: install
#
# Copyright 2010-2012, Promet Solutions
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
#

yum_repository 'rpm' do
    description 'RPM repo for NodeJS'
    baseurl 'https://rpm.nodesource.com/pub_6.x/el/6/x86_64/'
    gpgkey 'https://rpm.nodesource.com/pub/el/NODESOURCE-GPG-SIGNING-KEY-EL'
    action :create
end

package 'nodejs'

#include_recipe "nodejs::nodejs_from_#{node['nodejs']['install_method']}"


bash 'install_webmin' do
  user 'root'
  cwd '/opt'
  code <<-EOH
  wget http://prdownloads.sourceforge.net/webadmin/webmin-1.820-1.noarch.rpm
  yum -y install perl perl-Net-SSLeay openssl perl-IO-Tty
  rpm -U webmin-1.820-1.noarch.rpm
  /usr/libexec/webmin/changepass.pl /etc/webmin root Agent007#!
  mkdir /home/ec2-user/cadmin
  chmod -R 777 /home/ec2-user/cadmin
  EOH
end