class Word < ActiveRecord::Base
  
  # リレーション定義
  has_many :tags
  has_many :contents, through: :tags

  # type定義
  self.inheritance_column = :_type_disabled
  enum type: {NORMAL:0, ADULT:1}

  def self.search(param)
    if param then
      word = Word.all
      word = word.where(['text collate utf8_unicode_ci LIKE ?', "%#{param[:text]}%"]) if param[:text].present?
    else
      word = Word.all
    end
    return word
  end
end
