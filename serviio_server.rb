#!/usr/bin/env ruby

require 'optparse'

def server_cmd(cmd)
  unload = 1
  case cmd
  when 'start'
    puts "Starting server...\n"
    unload = 0 
  else
    puts "Stopping server...\n"
  end
  `sudo launchctl #{unload == 0 ? 'load' : 'unload'} -F /Library/LaunchDaemons/org.serviio.server.plist 2>&1`
end

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: ./serviio_server.rb [-e | --exec start|stop|restart]"

  options[:cmd] = nil
  opts.on( '-e', '--exec EXEC', 'start, stop, or restart' ) do |cmd|
    options[:cmd] = cmd.chomp
  end
end
optparse.parse!

cmd = options[:cmd]
unless cmd =~ /^(start|stop|restart)$/
  puts 'serviio_server.rb - Expecting start, stop, or restart switch. Exiting...'
  exit 1
end

STDOUT.sync = true
case cmd
when 'start'
  server_cmd(cmd)
when 'stop'
  server_cmd(cmd)
else
  server_cmd('stop')
  puts 'Sleeping 15 secs...'
  sleep 15
  server_cmd('start')
end

STDOUT.sync = false
exit 0
