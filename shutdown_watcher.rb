#!/usr/bin/env ruby

require 'net/http'
require 'aws-sdk'

puts Time.now

count = `netstat -nt | grep 4242 | wc -l`.strip.to_i
puts "current connections: #{count}"

if count == 0
	ip = Net::HTTP.get(URI.parse("http://169.254.169.254/latest/meta-data/public-ipv4"))

  ec2 = Aws::EC2::Client.new(region: 'us-east-1')
	mgr_inst  = ec2.describe_instances(filters: [
    {
      name: "tag:Name",
      values: ["starmade-mgr"],
    }
  ]).reservations.first.instances.first

puts "moving ip address"
	ec2.associate_address(
		instance_id: mgr_inst.instance_id,
		public_ip: ip)

puts "shutting down"
	`sudo shutdown -h now`
end
