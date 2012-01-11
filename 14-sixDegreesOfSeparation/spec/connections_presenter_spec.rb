require_relative '../social_network'

describe SocialNetwork do
  describe SocialNetwork::ConnectionsPresenter do
    describe 'displays social network for' do
      it 'single author with no connections' do
        connections = [SocialNetwork::Person.new("bob", [])]
        presenter = SocialNetwork::ConnectionsPresenter.new(connections)

        expected = StringIO.new
        expected.puts "bob"

        presenter.get_connections_presentation.should == expected.string
      end

      it 'multiple authors with no connections' do
        connections = [
          SocialNetwork::Person.new("bob", []),
          SocialNetwork::Person.new("nick", [])
        ]

        expected = StringIO.new
        expected.puts "bob"
        expected.puts ""
        expected.puts "nick"

        presenter = SocialNetwork::ConnectionsPresenter.new(connections)
        presenter.get_connections_presentation.should == expected.string
      end

      it 'first level connections' do
        connections = [
          SocialNetwork::Person.new("bob", %w{ nick }),
          SocialNetwork::Person.new("nick", %w{ bob })
        ]

        expected = StringIO.new
        expected.puts "bob"
        expected.puts "nick"
        expected.puts ""
        expected.puts "nick"
        expected.puts "bob"

        presenter = SocialNetwork::ConnectionsPresenter.new(connections)
        presenter.get_connections_presentation.should == expected.string
      end

      it 'multiple first level connections alphabetically' do
        connections = [
          SocialNetwork::Person.new("bob", %w{ sussane benjamin })
        ]

        expected = StringIO.new
        expected.puts "bob"
        expected.puts "benjamin, sussane"

        presenter = SocialNetwork::ConnectionsPresenter.new(connections)
        presenter.get_connections_presentation.should == expected.string
      end

      it 'second level connections' do
        connections = [
          SocialNetwork::Person.new("bob", %w{ susanne benjamin }),
          SocialNetwork::Person.new("susanne", %w{ anna }),
          SocialNetwork::Person.new("anna", [])
        ]

        expected = StringIO.new
        expected.puts "anna"
        expected.puts ""
        expected.puts "bob"
        expected.puts "benjamin, susanne"
        expected.puts "anna"
        expected.puts ""
        expected.puts "susanne"
        expected.puts "anna"

        presenter = SocialNetwork::ConnectionsPresenter.new(connections)
        presenter.get_connections_presentation.should == expected.string
      end

      it 'higher level connection takes precedence over lower level connection' do
        connections = [
          SocialNetwork::Person.new("bob", %w{ susanne benjamin }),
          SocialNetwork::Person.new("susanne", %w{ anna }),
          SocialNetwork::Person.new("anna", %w{ benjamin })
        ]

        expected = StringIO.new
        expected.puts "anna"
        expected.puts "benjamin"
        expected.puts ""
        expected.puts "bob"
        expected.puts "benjamin, susanne"
        expected.puts "anna"
        expected.puts ""
        expected.puts "susanne"
        expected.puts "anna"
        expected.puts "benjamin"

        presenter = SocialNetwork::ConnectionsPresenter.new(connections)
        presenter.get_connections_presentation.should == expected.string
      end
    end
  end
end
