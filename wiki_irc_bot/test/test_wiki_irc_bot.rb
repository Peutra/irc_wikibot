require 'minitest/autorun'
require 'wiki_irc_bot'

class WikiIrcBotTest < Minitest::Test
  def setup
    @welcome = WikiIrcBot::Welcome.new
  end
  def test_wib_initialize
    out = capture_io do
      @welcome.polite?("Hello bot")
    end
    puts out
    # assert_match("What would your search be today ?", out)
  end
end
