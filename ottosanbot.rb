#ツイート 
require "twitter"
require 'yaml'

keys = YAML.load_file('./config.yml')

client = Twitter::REST::Client.new do |config|
  config.consumer_key = keys["api_key"]
  config.consumer_secret = keys["api_secret"]
  config.access_token = keys["access_token"]
  config.access_token_secret = keys["access_token_secret"]
end

loop do
   File.open("tweets.txt", "r") do |bot|
     @bots = bot.read.split("\n")
   end
   tweet = @bots.sample
   sleep_time = 60 + rand(3600)
   t = Time.now
   if tweet == "time"
     tweet = t.strftime("Now is %H:%M")
   elsif tweet == "時間"
     tweet = t.strftime("%H時%M分なう")
   end
   puts "tweet #{tweet} (#{t}) next (#{t + sleep_time})"

   client.update tweet

   sleep sleep_time
end
