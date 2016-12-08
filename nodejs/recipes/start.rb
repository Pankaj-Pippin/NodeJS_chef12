Chef::Log.warn 'Killing nodejs'
# Download latest head
ENV['DIR'] = '/home/ec2-user/logs'
bash 'download_git' do
  user 'root'
  cwd '/opt'
  code <<-EOH
	if [[  -e /opt/concreetadmin-server ]]; then
		sudo rm -fr /opt/concreetadmin-server/
	fi
	sudo git clone  git@github.com:pippintech/concreetadmin-server.git
	#dir ="/home/ec2-user/logs"
	echo $DIR
	if [[ ! -e $DIR ]]; then
		mkdir $DIR 
		sudo chmod -R 755 $DIR 
	elif [[ ! -d $DIR  ]]; then
		echo "$dir already exists but is not a directory" 1>&2
	fi
  EOH
  flags "-x"
end



Chef::Log.info 'downloaded_git'  

# Stop Node js services
Chef::Log.warn 'Killing nodejs'

bash 'Killing_Node' do
  user 'root'
  cwd '/opt'
  code <<-EOH
		if ps ax | grep -v grep | grep node > /dev/null
		then
			sudo kill `pgrep grunt`
			sudo kill `pgrep gulp`
			sudo kill `pgrep node`
		fi
  EOH
  flags "-x"
end

Chef::Log.info 'Killed_Node'  

# Copy the code to final location
Chef::Log.warn 'Deploying code'

bash 'deploy_Codex' do
  user 'root'
  cwd '/opt'
  code <<-EOH
  	#mv /opt/concreetadmin-server/*.* /home/ec2-user/cadmin/
	TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
	LOGFILE="/home/ec2-user/logs/rsync_$TIMESTAMP.log"
	echo $LOGFILE
	#export rbLOGFILE=$LOGFILE
	mkdir /home/ec2-user/logs
	#kdir /home/ec2-user/logs
	cd /opt
	sudo git clone  git@github.com:pippintech/concreetadmin-server.git
	sudo rsync -avzh --remove-source-files /opt/concreetadmin-server/ /home/ec2-user/cadmin/ > $LOGFILE
	cd /home/ec2-user/cadmin/
	sudo rm -fr /opt/concreetadmin-server/
  EOH
end



Chef::Log.info 'deployed_Code'  

# Built the code & start serving

Chef::Log.warn 'Building code'

bash 'Building_Code' do
  user 'root'
  cwd '/home/ec2-user/cadmin/'
  code <<-EOH
    sudo chmod -R 755  /home/ec2-user/cadmin/
	sudo npm install
#	sudo nohup  grunt serve > /dev/null 2>&1 &
	sudo nohup  gulp serve:dist > /dev/null 2>&1 &
  EOH
  flags "-x"
end



Chef::Log.info 'Built_Code'  