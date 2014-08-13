require 'open3'

# List network services for user to pick from.
stdin, stdout = Open3.popen3 'networksetup', 'listallnetworkservices'
services = stdout.gets(nil).split("\n").drop(1)
services.each_with_index { |name, index| puts "#{index.to_s}) #{name}" }

# Loop until user picks a valid services.
choice = nil
until choice
    print 'Which service? '
    input = gets.strip!.to_i

    if services[input].nil?
        puts 'Sorry, that service is invalid...'
    else
        choice = services[input]
    end
end

# Check which DNS servers this network service is using.
stdin, stdout = Open3.popen3 'networksetup', '-getdnsservers', choice
dns_servers = stdout.gets(nil).split("\n")

if dns_servers.include? '208.122.23.23'
    # Remove Unblock-US DNS
    system "sudo networksetup -setdnsservers #{choice} Empty"
    puts "Unblock-Us removed from #{choice}."
else
    # Add Unblock-US DNS
    system "sudo networksetup -setdnsservers #{choice} 208.122.23.23 208.122.23.22"
    puts "Unblock-Us set on #{choice}."
end