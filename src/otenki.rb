require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'
require 'open-uri'

uri_weather = "https://tenki.jp/forecast/5/25/5030/22207/"

charset = nil
html = URI.open(uri_weather) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパース（解析）してオブジェクトを作成
doc = Nokogiri::HTML.parse(html, nil, charset)

weather = doc.xpath('//p[@class="weather-telop"]')[0].inner_text


uri = URI.parse("https://api.line.me/v2/bot/message/push")

http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = uri.scheme === "https"
token = "" #token
header = {
	"Content-Type" => "application/json",
	"Authorization" => "Bearer #{token}" 
}

body = { 
	"to" => "U0891b3d2e02743686c762412c953997f",
	"messages" => [
		{"type" => "text", "text" => "富士宮の天気: #{weather}"}
	]
}

response = http.post(uri.path, body.to_json, header)

p response.body

