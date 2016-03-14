#自動リプ

require "twitter"
require 'net/http'
require 'uri'
require 'json'
require 'yaml'

keys = YAML.load_file('./config.yml')

client_streaming = Twitter::Streaming::Client.new do |config|
  config.consumer_key = keys["api_key"]
  config.consumer_secret = keys["api_secret"]
  config.access_token = keys["access_token"]
  config.access_token_secret = keys["access_token_secret"]
end

client_rest = Twitter::REST::Client.new do |config|
  config.consumer_key = keys["api_key"]
  config.consumer_secret = keys["api_secret"]
  config.access_token = keys["access_token"]
  config.access_token_secret = keys["access_token_secret"]
end

USERNAME = "ottosan884_bot"

client_streaming.user do |object|
  case object
  when Twitter::Tweet
    username = object.user.screen_name # ユーザー名
    name = object.user.name            # アカウント名
    tweet = object.text                # ツイート内容
    tweet_id = object.id               # ツイートのID
    option = {:in_reply_to_status_id => tweet_id}

# お嬢をふぁぼる
    if (/お嬢/ =~ tweet) && (username != USERNAME)
      puts 'fav' + username + ':' + tweet
      client_rest.favorite(tweet_id)
    end

# 天気予報
    if (!tweet.index("RT")) && (username != USERNAME)
      if (/#お嬢天気予報/ =~ tweet)
        puts 'weather'+username + ':' + tweet
        if (/[^東]京都/ =~ tweet) || (/kyoto/i =~ tweet)
          uri = URI.parse('http://weather.livedoor.com/forecast/webservice/json/v1?city=260010')
        elsif (/大阪/ =~ tweet) || (/osaka/i =~ tweet)
          uri = URI.parse('http://weather.livedoor.com/forecast/webservice/json/v1?city=270000')
        else
          uri = URI.parse('http://weather.livedoor.com/forecast/webservice/json/v1?city=250010')
        end
        json = Net::HTTP.get(uri)
        result = JSON.parse(json)
        today_tel = result['forecasts'][0]['telop']
        tomor_tel = result['forecasts'][1]['telop']
        min_tem = result['forecasts'][1]['temperature']['min']['celsius']
        max_tem = result['forecasts'][1]['temperature']['max']['celsius']
        client_rest.update("@#{username} #{result['title']}\n#{result['link']}\n予報の発表日時: #{result['publicTime']}\n今日: #{today_tel}\n明日: #{tomor_tel} 最低#{min_tem}度 最高#{max_tem}度\n#お嬢天気予報", option) 

#お嬢の煽り
      elsif (/#お嬢の煽り/ =~ tweet)
        puts 'aori' + username + ':' + tweet
        files = Dir.glob("aori*")
        pic_id = client_rest.upload(File.new(files.sample))
        option = {
          :in_reply_to_status_id => tweet_id,
          :media_ids => pic_id
        }
        client_rest.update('@'+username+' #お嬢の煽り', option)

# 自動リプ
      elsif (/@ottosan884_bot/ =~ tweet)
        puts 'rep'+ username + ':' + tweet
        if(/会議/ =~ tweet)
          repl = "会議は長いもの"
        elsif (/たい$/ =~ tweet)
          re = tweet.delete("/@ottosan884_bot/")
          if (re.length <= 15)
            repl = re + "わかる"
          else
            repl = "うん"
          end
        else
          File.open("replies.txt", "r") do |reply|
            @rere = reply.read.split("\n")
          end
          re = @rere.sample
          if (re =~ /さん/)
            repl = name + re
          else
            repl = re
          end
        end
        puts ' >' + repl
        client_rest.update('@'+username+' '+repl, option)
      end
    end
  end
end