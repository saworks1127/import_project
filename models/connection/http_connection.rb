# 標準HTTP通信クラス
#  Author:: himeno
#  Date::   2016/10/01

require 'open-uri'

class HttpConnection < ConnectionBase

  # HTTP通信
  # ==== Args
  # url:: 対象url
  # ==== Return
  # response:: 取得結果オブジェクト
  # ==== Raise
  # none
  def self.fetch(url)
    response = open(url).read
    return response
  end
end