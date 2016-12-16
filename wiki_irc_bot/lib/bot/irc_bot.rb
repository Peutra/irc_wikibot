#! /usr/local/bin/ruby

# source : https://gist.githubusercontent.com/jingta/878465/raw/3a18dede43d6334b952f6d2e9bbf17e7e6dcda8a/irc_bot.rb

require "socket"

# Safe "tainted" data
# Taint checking is a feature in some computer programming languages, such as Perl[1] and Ruby,[2] designed to increase security by preventing malicious users from executing commands on a host computer.
$SAFE=1
# The irc class, which talks to the server and holds the main event loop
class IRC
  def initialize(server, port, wiki_bot, channel)
    @server = server
    @port = port
    @wiki_bot = wiki_bot
    @channel = channel
  end
  #connect to the IRC server
  def connect()
    @irc = TCPSocket.open(@server, @port)
    send "USER blablablabla :bla bla"
    send "BOT #{@wiki_bot} JOIN #{@channel}"
  end
  # Make sure we have a valid expression for security reasons if ok ok, if not ok error"
  def evaluate(s)
    # TODOTODOTODO
  end
  def handle_server_input(s)
    # TODOTODOTODO
  end
  # Send a message to the irc server and print to screen
  def send(s)
    puts ">>> #{s}"
    @irc.send "#{s}\n", 0
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
