set :passenger_restart_with_touch, true

server 'af-transit-app4.admin.umass.edu',
       roles: %w[app web],
       ssh_options: { forward_agent: false }
