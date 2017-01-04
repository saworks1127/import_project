class Appendix < ActiveRecord::Base

  # type定義
  self.inheritance_column = :_type_disabled
  enum type: {THUMBNAIL:0, EYECATCH:1}

  # リレーション定義
  belongs_to :content
  
  # サムネイル画像URLの設定
  # ==== Args
  # url :: (String)url
  # ==== Return
  # none
  # ==== Raise
  # none
  def set_thumbnail(url)
    self.text = url
    self.type = :THUMBNAIL
  end

  # アイキャッチ画像URLの設定
  # ==== Args
  # url :: (String)url
  # ==== Return
  # none
  # ==== Raise
  # none
  def set_eyecatch(url)
    self.text = url
    self.type = :EYECATCH
  end

end
