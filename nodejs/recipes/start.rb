Chef::Log.warn 'Start nodejs'

bash 'Start_Node' do
  user 'root'
  cwd '/home/ec2-user/cadmin'
  code <<-EOH
	sudo nohup  grunt serve > /dev/null 2>&1 &
  EOH
end

Chef::Log.info 'Started nodejs'