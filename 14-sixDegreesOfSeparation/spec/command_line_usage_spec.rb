require_relative '../social_network'

describe SocialNetwork do
  describe "command line usage" do
    it "presents a simple social network" do
      message_data = StringIO.new
      message_data.puts "alberta: @bob \"It is remarkable, the character of the pleasure we derive from the best books.\""
      message_data.puts "bob: \"They impress us ever with the conviction that one nature wrote and the same reads.\" /cc @alberta"
      message_data.puts "alberta: hey @christie. what will we be reading at the book club meeting tonight?"
      message_data.puts "christie: 'Every day, men and women, conversing, beholding and beholden.' /cc @alberta, @bob"
      message_data.puts "bob: @duncan, @christie so I see it is Emerson tonight"
      message_data.puts "duncan: We'll also discuss Emerson's friendship with Walt Whitman /cc @bob"
      message_data.puts "alberta: @duncan, hope you're bringing those peanut butter chocolate cookies again :D"
      message_data.puts "emily: Unfortunately, I won't be able to make it this time /cc @duncan"
      message_data.puts "duncan: @emily, oh what a pity. I'll fill you in next week."
      message_data.puts "christie: @emily, \"Books are the best of things, well used; abused, among the worst.\" -- Emerson"
      message_data.puts "emily: Ain't that the truth ... /cc @christie"
      message_data.puts "duncan: hey @farid, can you pick up some of those cookies on your way home?"
      message_data.puts "farid: @duncan, might have to work late tonight, but I'll try and get away if I can"
      message_data.rewind

      expected = StringIO.new
      expected.puts "alberta"
      expected.puts "bob, christie"
      expected.puts "duncan, emily"
      expected.puts "farid"
      expected.puts ""
      expected.puts "bob"
      expected.puts "alberta, christie, duncan"
      expected.puts "emily, farid"
      expected.puts ""
      expected.puts "christie"
      expected.puts "alberta, bob, emily"
      expected.puts "duncan"
      expected.puts "farid"
      expected.puts ""
      expected.puts "duncan"
      expected.puts "bob, emily, farid"
      expected.puts "alberta, christie"
      expected.puts ""
      expected.puts "emily"
      expected.puts "christie, duncan"
      expected.puts "alberta, bob, farid"
      expected.puts ""
      expected.puts "farid"
      expected.puts "duncan"
      expected.puts "bob, emily"
      expected.puts "alberta, christie"

      SocialNetwork.get_social_network(message_data).should == expected.string
    end
  end
end
