class Content < ActiveRecord::Base

  # type定義
  self.inheritance_column = :_type_disabled
  enum type: {HTML:0, XML:1, IMAGE:2, MOVIE:4}

  # リレーション定義
  belongs_to :target
  has_many :indicators, foreign_key: :content_id, dependent: :destroy
  has_many :appendixes, foreign_key: :content_id, dependent: :destroy
  
  has_many :tags, foreign_key: :content_id, dependent: :destroy
  has_many :words, through: :tags

  accepts_nested_attributes_for :appendixes
  accepts_nested_attributes_for :indicators
  accepts_nested_attributes_for :tags

  # 検索条件　fbshareのみ
  scope :contain_fbshare, -> {
    joins(:indicators).where(['indicators.type = ?', Indicator.types[:FB_SHARE]])
  }

  # 検索条件　指定のtagを含む
  scope :contain_tags, -> tags{
    joins(:words).where(words: {text: tags})
  }

  # 検索条件　指定のtargetのみ
  scope :where_target, -> target_ids{
    joins(:target).where(targets: {id: target_ids})
  }

  # 検索条件　発行日の範囲指定
  scope :published_date_between, -> from, to {
    if from.present? && to.present?
      where(published_date: from..to)
    elsif from.present?
      where('published_date >= ?', from)
    elsif to.present?
      where('published_date <= ?', to)
    end
  }

  # 検索条件　今日の人気順
  scope :today_ranking, -> {
    # fbshare数が取得されている
    # 日付が一日以内
    # fbshare数の降順
    contain_fbshare.published_date_between(Date.today - 1.day, nil).order(['indicators.value desc'])
  }

  # 検索条件　１時間以内
  scope :within_one_hour, -> {
    published_date_between(DateTime.now - 1.hour, nil)
  }

  # 検索処理
  # ==== Args
  # param :: content要素dictionary
  # ==== Return
  # none
  # ==== Raise
  # none
  def self.search(param)
    if param
      content = Content.all
      content = content.where(['id = ?', param[:id]]) if param[:id].present?
      content = content.where(['target_id = ?', param[:target_id]]) if param[:target_id].present?
      content = content.where(['type = ?', param[:type]]) if param[:type].present?
      content = content.where(['title LIKE ?', "%#{param[:title]}%"]) if param[:title].present?
      content = content.where(['text LIKE ?', "%#{param[:text]}%"]) if param[:text].present?
      content = content.where(['category_id = ?', param[:category_id]]) if param[:category_id].present?
      content = content.where(['published_date = ?', param[:published_date]]) if param[:published_date].present?
      return content
    else
      return Content.all
    end
  end

end
