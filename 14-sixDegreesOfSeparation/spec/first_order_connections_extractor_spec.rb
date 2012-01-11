require_relative '../social_network'

describe SocialNetwork do
  describe SocialNetwork::FirstOrderConnectionsExtractor do
    before(:each) do
      @extractor = SocialNetwork::FirstOrderConnectionsExtractor.new
    end

    describe 'finds first order connections among the supplied mentions' do
      it 'includes authors with no connections' do
        bob = SocialNetwork::Person.new("bob", [])

        @extractor.add_mentions("bob", %w{ albertha })
        @extractor.add_mentions("bob", %w{ simona })
        @extractor.extract_first_order_connections.should == [bob]
      end

      it 'discriminates unidirectional connections' do
        bob = SocialNetwork::Person.new("bob", [])
        simona = SocialNetwork::Person.new("simona", [])

        @extractor.add_mentions("bob", %w{ albertha })
        @extractor.add_mentions("simona", %w{ nick })
        @extractor.extract_first_order_connections.should == [bob, simona]
      end

      it "doesn't include mentions without messages" do
        bob = SocialNetwork::Person.new("bob", [])
        simona = SocialNetwork::Person.new("simona", [])

        @extractor.add_mentions("bob", %w{ nick })
        @extractor.add_mentions("simona", %w{ nick })
        @extractor.extract_first_order_connections.should == [bob, simona]
      end

      it 'detects first order connections (I mention you, you mention me)' do
        bob = SocialNetwork::Person.new("bob", [])
        simona = SocialNetwork::Person.new("simona", %w{ nick })
        nick = SocialNetwork::Person.new("nick", %w{ simona })

        @extractor.add_mentions("bob", %w{ nick })
        @extractor.add_mentions("simona", %w{ nick })
        @extractor.add_mentions("nick", %w{ simona })
        @extractor.extract_first_order_connections.should == [bob, simona, nick]
      end

      it 'allows for multiple connections' do
        bob = SocialNetwork::Person.new("bob", %w{ nick })
        simona = SocialNetwork::Person.new("simona", %w{ nick })
        nick = SocialNetwork::Person.new("nick", %w{ simona bob })

        @extractor.add_mentions("bob", %w{ nick })
        @extractor.add_mentions("simona", %w{ nick })
        @extractor.add_mentions("nick", %w{ simona bob })
        @extractor.extract_first_order_connections.should == [bob, simona, nick]
      end

      it "doesn't duplicate multiple connections" do
        bob = SocialNetwork::Person.new("bob", %w{ nick })
        simona = SocialNetwork::Person.new("simona", %w{ nick })
        nick = SocialNetwork::Person.new("nick", %w{ simona bob })

        @extractor.add_mentions("bob", %w{ nick })
        @extractor.add_mentions("simona", %w{ nick })
        @extractor.add_mentions("nick", %w{ simona bob })
        @extractor.add_mentions("nick", %w{ bob })
        @extractor.extract_first_order_connections.should == [bob, simona, nick]
      end
    end
  end
end
