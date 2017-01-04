# Torプロキシ経由・HTTP通信クラス
#  Author:: himeno
#  Date::   2016/10/01

# tor起動コマンド：tor --CookieAuthentication 0 --HashedControlPassword "" --ControlPort 9050 --SocksPort 50001

require 'net/telnet'
require 'socksify'
require 'socksify/http'

class TorConnection < ConnectionBase

  SOCKES_SERVER = Aldebaran::Application.config.sockes_server
  SOCKES_PORT = Aldebaran::Application.config.sockes_port
  TOR_PORT =  Aldebaran::Application.config.tor_port
  TOR_TIMEOUT = Aldebaran::Application.config.tor_timeout

  WAIT_SECONDS = 10
  TOR_PROMPT_OK = "250 OK\n"

  # 前回の経路リセット時刻
  @@reset_timestamp = DateTime.now

  # HTTP通信
  # ==== Args
  # url:: 対象url
  # ==== Return
  # response:: 取得結果オブジェクト
  # ==== Raise
  # none
  def self.fetch(url)
    uri = URI.parse(url)
    TCPSocket::socks_server = SOCKES_SERVER
    TCPSocket::socks_port = SOCKES_PORT
    Net::HTTP.SOCKSProxy(SOCKES_SERVER, SOCKES_PORT).start(uri.host, uri.port) do |http|
      response = http.get(uri.path)
      return response.body
    end
  end

  # Torの経路変更（自IPアドレスの変更）
  # ==== Args
  # none
  # ==== Return
  # none
  # ==== Raise
  # none
  def self.reset_tor_circuit
    # 前回実行時から一定時間経過していなけば待機
    if (@@reset_timestamp + WAIT_SECONDS.seconds) > DateTime.now
      p 'reset waiting ...'
      sleep WAIT_SECONDS
    end

    p 'reset tor circuit ...'

    tor_client = Net::Telnet::new('Host' => SOCKES_SERVER, 
                                  'Port' => TOR_PORT, 
                                  'Timeout' => TOR_TIMEOUT, 
                                  'Prompt' => /#{TOR_PROMPT_OK}/)
    send_command(tor_client, 'AUTHENTICATE ""')
    send_command(tor_client, 'signal NEWNYM')
    tor_client.close

    @@reset_timestamp = DateTime.now
    p 'reset finished.'
  end

  # clientへのコマンド送信
  # ==== Args
  # client:: telnet接続したclient
  # message:: コマンド文字列
  # ==== Return
  # none
  # ==== Raise
  # none
  def self.send_command(client, message)
      client.cmd(message) { |console| 
      if console != TOR_PROMPT_OK
        p console 
        raise console
      end
    }    
  end

end
