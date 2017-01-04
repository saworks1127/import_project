# ContentFbShareクラス
#  Author:: himeno
#  Date::   2016/10/01

class ContentFbShare < Indicator

  # インスタンス取得
  # ==== Args
  # content_id :: (Integer)content_id
  # ==== Return
  # none
  # ==== Raise
  # none
  def self.build(content_id)
    return ContentFbShare.find_or_initialize_by(content_id: content_id, type: Indicator.types[:FB_SHARE])
  end

  # 更新（ない場合は作成）
  # ==== Args
  # none
  # ==== Return
  # none
  # ==== Raise
  # none
  def update()
    if self.update_require?(DateTime.now)
      # 更新が必要な場合、取得・保存
      share_count = FbShareCountApi.new(self.content.text).fetch
      self.value = share_count
      self.save
      p 'success : ' + share_count.to_s + ' shares'
      return true
    else
      # 更新不要
      return false
    end
  end

  # HACK : 簡略化
  #
  # 更新可否判定
  # ==== Args
  # none
  # ==== Return
  # none
  # ==== Raise
  # none
  def update_require?(exec_date)
    content = self.content

    # 新規時
    if self.value.blank?
      p 'matched : 新規コンテンツ'
      return true
    end

    # １日以内なら６ｈ毎
    if ((content.published_date.day - exec_date.day) > 1 ) && ((exec_date.hour - self.updated_at.hour) > 6)
      p 'matched : ' + self.updated_at.to_s + " published_date が１日以内 且つ indicator.updated_at から６時間経過"
      return true
    end

    # ３日以内なら１２ｈ毎
    if ((content.published_date.day - exec_date.day) > 3 ) && ((exec_date.hour - self.updated_at.hour) > 12)
      p 'matched : ' + self.updated_at.to_s + " published_date が３日以内 且つ indicator.updated_date から１２時間経過"
      return true
    end

    # ７日以内なら２４ｈ毎
    if ((content.published_date.day - exec_date.day) > 7 ) && ((exec_date.hour - self.updated_at.hour) > 24)
      p 'matched : ' + self.updated_at.to_s + " published_date が７日以内 且つ indicator.updated_date から２４時間経過"
      return true
    end

    # 以降なら３ｄ毎
    if ((exec_date.day - self.updated_at.day) > 3)
      p 'matched : ' + self.updated_at.to_s + " indicator.updated_date から３日経過"
      return true
    end

    # 更新不要
    return false
  end
end
