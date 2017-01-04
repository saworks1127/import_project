# facebook シェア数取得APIクラス
#  Author:: himeno
#  Date::   2016/10/01

class FbShareCountApi < FbApi

  # JSON取得
  # ==== Args
  # none
  # ==== Return
  # share_count:: share数
  # ==== Raise
  # none
  def fetch

    json_dic = super

    # 要素チェック、なければ0（errorの場合も含む）
    share = json_dic['share']
    if share.blank?
      return 0
    end

    # 要素チェック、なければ0
    share_count = share['share_count']
    if share_count.blank?
      return 0
    end

    # シェア数の保存
    return share_count
  end
end