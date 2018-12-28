require 'twitter'

class WeatherBot
	def tweet_forecast
		twitter_client.update '今日は晴れです'
	end

	def twitter_client
		Twitter::REST::Client.new
	end
end

it 'エラーなく予報をツイートすること' do
	weather_bot = WeatherBot.new
	expect{weather_bot.tweet_forecast}.not_to raise_error
end
#Twitterと連携する部分はモックに置き換える

it 'エラーなく予報をツイートすること' do
	#clientのモックを作る
	#"Twitter client" の部分が double に渡した引数
	twitter_client_mock = double('Twitter client')
	#updateメソッドが呼び出せるように
	allow(twitter_client_mock).to receive(:update)
	weather_bot = WeatherBot.new
	# twitter_clientメソッドが呼ばれたら上で作ったモックを返すように実装を書き換える
	allow(weather_bot).to receive(:twitter_client).and_return(twitter_client_mock)
	expect{weather_bot.tweet_forecast}.not_to raise_error


#explanation above
#最初に Twitter::REST::Client のニセモノ、つまりモックを作る
#double というメソッドを使うと、モックオブジェクトを作れる
#twitter_client_mock = double('Twitter client')
#allow(モックオブジェクト).to receive(メソッド名) の形で、モックに呼び出し可能なメソッドを設定できる

#モックのメソッドがちゃんと呼び出されることを検証する
#allow => expectに変更

#わざとエラーを発生させてエラー処理をテストする

class WeatherBot
	def tweet_forecast
		twitter_client.update '今日は晴れです'
	rescue => e
		notify(e)
	end
	#errorをeに格納
	
	def twitter_client
		Twitter::REST::Client.new
	end

	def notify(error)
		#errorの通知
	end
end


#エラーが起きたら notify メソッドが呼ばれること」を検証

it 'エラーが起きたら通知すること' do
	twitter_client_mock = double('Twitter client')
 allow(twitter_client_mock).to receive(:update).and_raise('エラーが発生しました')
#人工的にエラーを発生させる
	weather_bot = WeatherBot.new
	allow(weather_bot).to receive(:twitter_client).and_return(twitter_client_mock)
	expect(weather_bot).to receive(:notify)
	weather_bot.tweet_forecast
end

#引数の内容を検証する
expect(twitter_client_mock).to receive(:update).with('今日は晴れです')
#引数の内容が晴れであることを検証する。

#2つ以上の引数を受け取る場合
#expect(user).to receive(:save_profile).with('Alice', alice@example.com)

#ハッシュを引数として渡す場合
expect(user).to receive(:save_profile).with(name: 'Alice', email: 'alice@e')
expect(user).to receive(:save_profile).with(hash_including(name: 'Alice))

it 'エラーなく予報をツイートすること' do
	twitter_client_mock = double('Twitter client')
	allow(twitter_client_mock).to receive(:update)
# WeatherBotクラスの全インスタンスに対して、twitter_clientメソッドが呼ばれたときにモックを返すようにする
 allow_any_instance_of(WeatherBot).to receive(:twitter_client).and_return(twitter_client_mock)

	weather_bot = WeatherBot.new
	expect{weather_bot.tweet_forecast}.not_to raise_error
end

class WeatherBot
	def search_first_weather_tweet
		twitter_client.search('天気').first.text
	end

	def tweet_forecast
		#
	end
	def twitter_client
		Twitter::REST::Client.new
		end
end

#search_first_weather_tweet は '天気' というキーワードでTwitterを検索し、最初に返ってきたツイートの本文を返すメソッド

it '天気を含むツイートを返すこと' do
	status_mock = double('Status')
	allow(status_mock).to receive(:text).and_return('西脇市の天気は曇りです')

	twitter_client_mock = double('Twitter client')
	allow(twitter_client_mock).to receive(:search).and_return([status_mock])

	weather_bot = WeatherBot.new
 allow(weather_bot).to receive(:twitter_client).and_return(twitter_client_mock)

	expect(weather_bot.search_first_weather_tweet).to eq '西脇市の天気は曇りです'
end

#モックを何個も作って連結する場合：receive_message_chain
it '「天気」を含むツイートを返すこと' do
	weather_bot = WeatherBot.new
	allow(weather_bot).to receive_message_chain('twitter_client.search.first.text').and_return('西脇市の天気は曇りです')
	expect(weather_bot.search_first_weather_tweet).to eq '西脇市の天気は曇りです'
end

#「twitter_client => search => first => text」と4つのメソッドを呼び出した結果を一気にモック化

