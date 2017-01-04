class Target < ActiveRecord::Base
  # type定義
  enum format: {RSS:0, HTML:1, XML:2}

  # リレーション定義
  has_many :contents, dependent: :destroy
  has_one :target_information, dependent: :destroy
  accepts_nested_attributes_for :contents

  
  # targetの検索処理
  # ==== Args
  # param :: 検索パラメータ
  # ==== Return
  # none
  # ==== Raise
  # none
  def self.search(param)
    if param
      target = Target.all
      target = target.where(['id = ?', param[:id]]) if param[:id].present?
      target = target.where(['target_information_id = ?', param[:target_information_id]]) if param[:target_information_id].present?
      target = target.where(['format = ?', Target.formats[param[:format]]]) if param[:format].present?
      target = target.where(['url LIKE ?', "%#{param[:url]}%"]) if param[:url].present?
      return target
    else
      return Target.all
    end
  end

  # google newsか判定
  # ==== Args
  # none
  # ==== Return
  # none
  # ==== Raise
  # none
  def is_google_news?
    return self.url.include?('news.google.com')
  end

end
