# facebook APIクラス
#  Author:: himeno
#  Date::   2016/10/01

class FbApi < SocialApiBase
  # API
  API_URL = 'http://graph.facebook.com/'
  
  # 初期化
  # ==== Args
  # url:: 対象url
  # ==== Return
  # none
  # ==== Raise
  # none
  def initialize(url)
    @api_param = url
    @try_limit = 1
    @try_count = 0
  end

  # JSON取得
  # ==== Args
  # url:: 対象url
  # ==== Return
  # json_dic:: jsonディクショナリ
  # ==== Raise
  # none
  def fetch
    begin
      # TOR経由実行
      json_text = TorConnection.fetch(API_URL + @api_param)
      json_dic = JSON.parser.new(json_text).parse()
      @try_count += 1

      # エラー値の場合
      if json_dic['error'].present?
        raise FbApiException.new(json_dic['error'])
      end
  
      return json_dic

    rescue FbApiException => e
      # 実行制限エラーの場合のみ、IPアドレス変更
      if e.is_type_throttling
        TorConnection.reset_tor_circuit
      end

      if @try_count <= @try_limit
        p 'fb_api retrying ...'
        retry
      else
        p 'fb_api failed.'
        raise e
      end
    end
  end
end
