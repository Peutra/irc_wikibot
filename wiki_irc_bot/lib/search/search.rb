class WikiIrcBot::Search

  require 'net/http'
  require "erb"
  require 'json'
  include ERB::Util

  STRING1 = "https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&continue=&srsearch="
  STRING3 = "&srwhat=text&srprop=timestamp"
  STRING4 = "https://en.wikipedia.org/wiki/"

  def returnResults(string2)
    url = STRING1 + string2 + STRING3
    uri = URI(url)
    content = Net::HTTP.get(uri)
    return craftResults(JSON.parse(content))
  end

  def craftResults(content)
    hash = Hash.new
    content["query"]["search"].each do |line|
        hash[line["title"]] = STRING4 + url_encode(line["title"].tr(" ", "_"))
    end
    return hash
  end

end
