require 'open3'

Shoes.app title: 'Unblock-Us Mac', width: 250, height: 250 do
    stack margin: 15 do
        # Get network services for user to pick from.
        stdin, stdout = Open3.popen2 'networksetup', 'listallnetworkservices'
        services = stdout.gets(nil).split("\n").drop(1)

        # List network services.
        para 'Netwrok Service:'
        services_box = list_box items: services, margin: [0, 0, 0, 10]

        # Ask for sudo password.
        para 'System Password:'
        password = edit_line secret: true, margin: [0, 0, 0, 10]

        button 'Apply Changes' do
            service = services_box.text

            # Check which DNS servers this network service is using.
            stdin, stdout = Open3.popen3 'networksetup', '-getdnsservers', service
            dns_servers = stdout.gets(nil).split("\n")

            if dns_servers.include? '208.122.23.23'
                # Remove Unblock-US DNS
                system "echo #{password.text} | sudo -S networksetup -setdnsservers #{service} Empty"
                alert "Unblock-Us removed from #{service}."
            else
                # Add Unblock-US DNS
                system "echo #{password.text} | sudo -S networksetup -setdnsservers #{service} 208.122.23.23 208.122.23.22"
                alert "Unblock-Us set on #{service}."
            end
        end
    end
 end