class WikiIrcBot
  require 'bot/irc_bot'
  require 'interaction/welcome'
  def self.wib
    # The main program
    # If we get an exception, then print it out and keep going (we do NOT want
    # to disconnect unexpectedly!)
    irc = IRC.new('127.0.0.1', 6667, 'wikibot', '#testbot')    
    irc.connect()
    begin
        irc.main_loop()
    rescue Interrupt
    rescue Exception => detail
        puts detail.message()
        print detail.backtrace.join("\n")
        retry
    end
  end
end
