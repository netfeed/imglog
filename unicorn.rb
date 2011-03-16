require 'fileutils'

# set path to app that will be used to configure unicorn, 
# note the trailing slash in this example
@dir = File.join(File.expand_path("..", __FILE__), '/')

worker_processes 4
working_directory @dir

timeout 10

# taken from https://github.com/blog/517-unicorn
# basically removes the need to do a "kill -QUIT" after a "kill -USR2"
before_fork do |server, worker|
  old_pid = "#{@dir}/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

sockets = "#{@dir}tmp/sockets"
pids = "#{@dir}tmp/pids"
logs = "#{@dir}log/"

[sockets, pids, logs].each do |dir|
  FileUtils.mkdir_p dir unless File.exists? dir
end

# Specify path to socket unicorn listens to, 
# we will use this in our nginx.conf later
listen "#{sockets}/unicorn.sock", :backlog => 64

# Set process id path
pid "#{pids}/unicorn.pid"

# Set log file paths
stderr_path "#{logs}unicorn.stderr.log"
stdout_path "#{logs}unicorn.stdout.log"