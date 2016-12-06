app = search(:aws_opsworks_app).first
app_path = "/srv/#{app['shortname']}"

  Chef::Log.info("path : ")
    Chef::Log.info(app_path)