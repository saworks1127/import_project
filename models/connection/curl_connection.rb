# Curlコマンド使用・HTTP通信クラス
#  Author:: himeno
#  Date::   2016/10/01

# HACK:名称が適切でない
# （curlを使用して接続するクラスであるが、http通信であることに変わりない）

require 'open3'

class CurlConnection < ConnectionBase

  # Curlコマンド実行・JSON取得
  # ==== Args
  # url:: 対象url
  # ==== Return
  # response:: 取得結果オブジェクト
  # ==== Raise
  # none
  def self.fetch(url)
    response, error, status = Open3.capture3("curl -sL #{url}")
    return response
  end

  # FOR DEBUG
  #
  # 自IPアドレス取得・確認
  # NOTICE:外部APIに依存するため連打しないこと
  # ==== Args
  # none
  # ==== Return
  # ip_address:: IPアドレス文字列
  # ==== Raise
  # none
  def self.get_ip_address
    p 'get IP address ...'
    json_text = fetch('ipinfo.io')
    json_dic = JSON.parser.new(json_text).parse()
    p 'current ip address : ' + json_dic['ip']
    return json_dic['ip']
  end

  # FOR DEBUG
  #
  # プロキシ経由・自IPアドレス取得・確認
  # NOTICE:外部APIに依存するため連打しないこと
  # ==== Args
  # none
  # ==== Return
  # ip_address:: IPアドレス文字列
  # ==== Raise
  # none
  def self.get_proxy_ip_address
    p 'get Proxy IP address ...'
    json_text = fetch("--socks5  #{SOCKES_SERVER}:#{SOCKES_PORT} ipinfo.io")
    json_dic = JSON.parser.new(json_text).parse()
    p 'current Proxy ip address : ' + json_dic['ip']
    return json_dic['ip']
  end

end