# source : https://gist.githubusercontent.com/jingta/878465/raw/3a18dede43d6334b952f6d2e9bbf17e7e6dcda8a/irc_bot.rb

require "socket"

# Safe "tainted" data
# Taint checking is a feature in some computer programming languages, such as Perl[1] and Ruby,[2] designed to increase security by preventing malicious users from executing commands on a host computer.
$SAFE=1
# The irc class, which talks to the server and holds the main event loop
class IRC
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
    @irc.puts "PRIVMSG #{@channel} :Write '@wikibot search [something]'"
  end
  # Make sure we have a valid expression for security reasons if ok ok, if not ok error"
  def evaluate(s)
    # TODOTODOTODO
  end
  def handle_server_input(s)
    # This isn't at all efficient, but it shows what we can do with Ruby
    # (Dave Thomas calls this construct "a multiway if on steroids")
    case s.strip
        when /^PING :(.+)$/i
            puts "[ Server ping ]"
            send "PONG :#{$1}"
        when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s.+\s:[\001]PING (.+)[\001]$/i
            puts "[ CTCP PING from #{$1}!#{$2}@#{$3} ]"
            send "NOTICE #{$1} :\001PING #{$4}\001"
        when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s.+\s:[\001]VERSION[\001]$/i
            puts "[ CTCP VERSION from #{$1}!#{$2}@#{$3} ]"
            send "NOTICE #{$1} :\001VERSION Ruby-irc v0.042\001"
        when /^:(.+?)!(.+?)@(.+?)\sPRIVMSG\s(.+)\s:#{@nick}: (.+)$/i
            puts "[ EVAL #{$5} from #{$1}!#{$2}@#{$3} ]"
            # nick, client, host, room, msg
            send "PRIVMSG #{(($4==@nickname)?$1:$4)} :#{evaluate($5)}"
        else
            puts s
    end
  end
  # Send a message to the irc server and print to screen
  def send(s)
    @irc.puts "PRIVMSG #{@channel} #{s}"
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
          send s
          # TODOTODO ELSE FOR HANDLING SERVER INPUTS
        end
      end
    end
  end
end
