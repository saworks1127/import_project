# 通信ベースクラス
#  Author:: himeno
#  Date::   2016/10/01

class ConnectionBase

  # 取得
  # （通信方式は継承クラスで実装する）
  # ==== Args
  # url:: 対象url
  # ==== Return
  # response:: 取得結果オブジェクト
  # ==== Raise
  # none
  def self.fetch(url)
    # implement in inherited class
  end

end