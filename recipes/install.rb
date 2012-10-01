#
# Cookbook Name:: phpbuild
# Recipe:: install
#
#  Copyright 2012 Ryan J. Geyer
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

rightscale_marker :begin

# TODO: Could probably install pre-reqs for other OS's
if node['platform'] == 'mac_os_x'
  %w{jpeg libpng mcrypt imagemagick gd libtool libxml2 autoconf}.each do |p|
    package p
  end
end

tempdir = ::File.join(Chef::Config['file_cache_path'], 'phpbuild')
unless ::File.directory?(node['phpbuild']['install_dir'])
  git tempdir do
    repository node['phpbuild']['git_uri']
    revision 'master'
    action :checkout
  end

  bash "Run the phpbuild installer" do
    cwd tempdir
    code <<-EOF
PREFIX=#{node['phpbuild']['install_dir']} ./install.sh
    EOF
  end
else
  log "phpbuild is already installed at #{node['phpbuild']['install_dir']} skipping installation..."
end

rightscale_marker :end
