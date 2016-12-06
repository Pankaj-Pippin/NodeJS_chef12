Chef::Log.warn 'Killing nodejs'

bash 'Kill_Node' do
  user 'root'
  cwd '/opt'
  code <<-EOH
if ps ax | grep -v grep | grep node > /dev/null
then
    sudo kill `pgrep grunt`
    sudo kill `pgrep node`
fi
  EOH
end

Chef::Log.info 'Killed nodejs'