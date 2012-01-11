require_relative '../social_network'

describe SocialNetwork do
  describe SocialNetwork::MentionsExtractor do
    before(:all) do
      @extractor = SocialNetwork::MentionsExtractor.new
    end

    describe 'extracts author & mentioned contacts from message' do
      it 'with mentions at the beginning' do
        @extractor.extract_mentions(
          "alberta: @bob \"It is remarkable, the character of the pleasure we derive from the best books.\""
        ).should == ["alberta", ["bob"]]
      end

      it 'with mention at the end' do
        @extractor.extract_mentions(
          "bob: \"They impress us ever with the conviction that one nature wrote and the same reads.\" /cc @alberta"
        ).should == ["bob", ["alberta"]]
      end

      it 'mention in the middle' do
        @extractor.extract_mentions(
          "alberta: hey @christie. what will we be reading at the book club meeting tonight?"
        ).should == ["alberta", ["christie"]]
      end

      it 'two mentions in the same message' do
        @extractor.extract_mentions(
          "christie: 'Every day, men and women, conversing, beholding and beholden.' /cc @alberta, @bob"
        ).should == ["christie", ["alberta", "bob"]]
      end

      it 'multiple mentions' do
        @extractor.extract_mentions(
          "bob: @duncan, @christie so I see it is Emerson tonight with @walt too?"
        ).should == ["bob", ["duncan", "christie", "walt"]]
      end

      it 'semicolon in the content' do
        @extractor.extract_mentions(
          "alberta: @duncan, hope you're bringing those peanut butter chocolate cookies again :D"
        ).should == ["alberta", ["duncan"]]
      end

      it 'no mentions' do
        @extractor.extract_mentions(
          "emily: Unfortunately, I won't be able to make it this time"
        ).should == ["emily", []]
      end
    end
  end
end
