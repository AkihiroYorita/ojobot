
require "twitter"
require 'yaml'

keys = YAML.load_file('./config.yml')

client = Twitter::REST::Client.new do |config|
  config.consumer_key = keys["api_key"]
  config.consumer_secret = keys["api_secret"]
  config.access_token = keys["access_token"]
  config.access_token_secret = keys["access_token_secret"]
end

USERNAME = '@ottosan884_bot'

loop do
	follower_ids = []
	client.follower_ids(USERNAME).each do |id|
  		follower_ids.push(id)
	end
 
	friend_ids = []
	client.friend_ids(USERNAME).each do |id|
  		friend_ids.push(id)
	end
 
	client.follow(follower_ids - friend_ids)

	sleep 3600
end