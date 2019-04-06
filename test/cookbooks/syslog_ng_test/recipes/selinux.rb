#
# Cookbook:: bmhughes_net_nginx_test
# Recipe:: selinux
#
# Copyright:: 2019, Ben Hughes, All Rights Reserved.

execute 'selinux-permissive' do
  not_if "/usr/sbin/getenforce | egrep -qx 'Disabled|Permissive'"
  command '/usr/sbin/setenforce 0'
end
