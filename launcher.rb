#!/usr/bin/env ruby

require 'aws-sdk'
require 'socket'

server = TCPServer.new 4242
puts 'listening'
loop do
  client = server.accept    # Wait for a client to connect
	puts 'received connection'
  client.close

  ec2 = Aws::EC2::Client.new(region: 'us-east-1')
	game_inst  = ec2.describe_instances(filters: [
    {
      name: "tag:Name",
      values: ["starmade"],
    }
  ]).reservations.first.instances.first

	if  game_inst.state.name == "stopped"
		ec2.start_instances(instance_ids: [ game_inst.instance_id ])

		begin
			sleep 10
			ip = Net::HTTP.get(URI.parse("http://169.254.169.254/latest/meta-data/public-ipv4"))
			ec2.associate_address(
				instance_id: mgr_inst.instance_id,
				public_ip: ip)
		rescue
			puts $!.inspect
			puts $!.backtrace.join("\n")
			retry
		end
	else
		puts "game server already running, why did I get a connection?"
	end
end
