module SocialNetwork
  class MentionsExtractor
    def extract_mentions(message)
      mentions = []
      from = message[0..(message.index(":")-1)]

      message.scan(/@(\w*)/) do |to|
        mentions << to
      end

      return from, mentions.flatten
    end
  end

  class Person
    include Comparable
    attr :nick, :connections

    def initialize(nick, connections)
      raise ArgumentError, "person nick must be defined" unless nick && !nick.empty?
      @nick = nick
      @connections = (connections && !connections.empty? ? connections : [])
    end

    def <=>(anOther)
      return 0 if @nick == anOther.nick && @connections == anOther.connections
      return -1 if @nick < anOther.nick || @nick == anOther.nick && @connections < anOther.connections
      1
    end

    def to_s
      "#{nick} connected to: #{connections.join(", ")}"
    end
  end

  class FirstOrderConnectionsExtractor
    attr_reader :connections

    def initialize
      @connections = {}
    end

    def add_mentions(from, new_mentions)
      mentions = @connections[from] || []
      mentions += new_mentions
      @connections[from] = mentions.uniq
    end

    def extract_first_order_connections
      # remove mentions that are unidirectional
      bidirectional = {}
      @connections.each do |from, mentions|
        mentions.each do |mention|
          if @connections.has_key?(mention) && @connections[mention].include?(from)
            connections = bidirectional[from] || []
            connections << mention
            bidirectional[from] = connections.uniq
          end
        end
        # don't forget persons with no connections
        bidirectional[from] = [] unless bidirectional[from]
      end

      # prepare first order connections
      first_order_connections = []
      bidirectional.each do |nick, connections|
        first_order_connections << Person.new(nick, connections)
      end
      first_order_connections
    end
  end

  class ConnectionsPresenter
    attr_reader :first_order_connections

    def initialize(first_order_connections)
      raise ArgumentError, "" unless first_order_connections
      @first_order_connections = first_order_connections.sort
    end

    def get_connections_presentation
      presentation = []
      social_network = prepare_connections_presentation
      social_network.each do |person, connections|
        single_person_presentation = person + "\n"
        connections.values.uniq.sort.each do |level|
          single_person_presentation += connections.select { |connection, connection_level| connection_level == level}.keys.sort.join(", ") + "\n"
        end
        presentation << single_person_presentation
      end
      presentation.join("\n")
    end

    def prepare_connections_presentation
      connections = {}
      @first_order_connections.each do |person|
        person_connections = {}
        person.connections.each do |connection|
          person_connections[connection] = 0
        end
        person.connections.each do |connection|
          add_next_level_connections(connection, 1, person_connections)
        end
        person_connections.delete(person.nick)
        connections[person.nick] = person_connections
      end
      connections
    end

    def add_next_level_connections(nick, level, connections)
      @first_order_connections.select{ |person| person.nick == nick }.each do |person|
        person.connections.each do |connection|
          current_level = connections[connection]
          if !current_level
            connections[connection] = level
            add_next_level_connections(connection, level + 1, connections)
          elsif level < current_level
            connections[connection] = level
          end
        end
      end
    end
  end

  def self.get_social_network(messages_data)
    raise ArgumentError, "Can't work without messages" unless messages_data
    raise ArgumentError, "Messages must be readable" unless messages_data.respond_to?(:gets)

    mentions_extractor = MentionsExtractor.new
    connections_extractor = FirstOrderConnectionsExtractor.new
    while message = messages_data.gets
      from, mentions = mentions_extractor.extract_mentions(message)
      connections_extractor.add_mentions(from, mentions)
    end
    connections_presenter = ConnectionsPresenter.new(connections_extractor.extract_first_order_connections)
    connections_presenter.get_connections_presentation
  end
end
