# ソーシャル系APIベースクラス
#  Author:: himeno
#  Date::   2016/10/01

class SocialApiBase
  attr_accessor :api_param
  attr_accessor :try_limit
  attr_accessor :try_count

  # 初期化
  # ==== Args
  # none
  # ==== Return
  # none
  # ==== Raise
  # none
  def initialize
    # implement in inherited class
  end

  # response取得
  # ==== Args
  # none
  # ==== Return
  # none
  # ==== Raise
  # none
  def fetch
    # implement in inherited class
  end

end