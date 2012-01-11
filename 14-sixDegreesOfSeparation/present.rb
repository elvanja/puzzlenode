require_relative 'social_network'

raise ArgumentError, "Couldn't find file with messages" unless ARGV[0] && File.exist?(ARGV[0])
messages = File.open(ARGV[0])

puts SocialNetwork.get_social_network(messages)
