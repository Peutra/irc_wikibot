# source : https://gist.githubusercontent.com/jingta/878465/raw/3a18dede43d6334b952f6d2e9bbf17e7e6dcda8a/irc_bot.rb

require "socket"

# Safe "tainted" data
# Taint checking is a feature in some computer programming languages, such as Perl[1] and Ruby,[2] designed to increase security by preventing malicious users from executing commands on a host computer.
$SAFE=1
# The irc class, which talks to the server and holds the main event loop
class WikiIrcBot::IRC
  def initialize(server, port, nickname, channel)
    @server = server
    @port = port
    @nickname = nickname
    @channel = channel
  end
  #connect to the IRC server
  def connect()
    @irc = TCPSocket.open(@server, @port)
    print("addr: ", @irc.addr.join(":"), "\n")
    print("peer: ", @irc.peeraddr.join(":"), "\n")
    @irc.puts "USER testing 0 * Testing"
    @irc.puts "NICK #{@nickname}"
    @irc.puts "JOIN #{@channel}"
    @irc.puts "PRIVMSG #{@channel} :Hello from wikibot"
    @irc.puts "PRIVMSG #{@channel} :Type '@wikibot search [something]'"
  end
  # Make sure we have a valid expression for security reasons if ok ok, if not ok error"
  def evaluate(s)
    # TODOTODOTODO
  end
  def handle_server_input(s)
    puts "#{s}"
    if s.include? "Hello"
        @irc.puts "PRIVMSG #{@channel} :Hello bastard"
      elsif s.include? "@wikibot search "
        ## GET EVERYTHING AFTER "search"
        midsubstring = s.match(/(?<=@wikibot search).*/)[0]
        endsubstring = midsubstring[1, midsubstring.length]
        ## LAUNCH DA SHIT
        result = WikiIrcBot::Search.new.returnResults(endsubstring)
        result.each_with_index do | (key, value), index |
          if index < 9
            @irc.puts "PRIVMSG #{@channel} :#{index + 1}    | #{key} => #{value}"
          else
            @irc.puts "PRIVMSG #{@channel} :#{index + 1}   | #{key} => #{value}"
          end
        end
      else
        return
    end
  end
  # Keeps on doing things yeah
  def main_loop()
    while true
      ready = select([@irc, $stdin], nil, nil, nil)
      next if !ready
      for s in ready[0]
          if s == $stdin then
              return if $stdin.eof
              s = $stdin.gets
          elsif s == @irc then
              return if @irc.eof
              s = @irc.gets
              handle_server_input(s)
          end
      end
    end
  end
end
