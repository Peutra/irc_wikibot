class WikiIrcBot::Welcome
  def initialize
    puts "Hello dear. Please say 'Hello bot'"
    welcome = gets.chomp
    self.polite?(welcome)
  end

  def polite?(welcome)
    if welcome === "Hello bot"
      puts "What would your search be today ?"
    else
      puts "Please be polite and say 'Hello bot'"
    end
  end
end
