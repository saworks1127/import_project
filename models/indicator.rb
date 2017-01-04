class Indicator < ActiveRecord::Base
  # type定義
  self.inheritance_column = :_type_disabled
  enum type: {PV:0, FB_SHARE:1}

  # リレーション定義
  belongs_to :content

  # 制約
  validates :content_id, uniqueness: { scope: [:type] }
end
