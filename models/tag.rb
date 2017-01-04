class Tag < ActiveRecord::Base

  # リレーション定義
  belongs_to :content
  belongs_to :word

  # タグの設定
  # ==== Args
  # tags :: (Array)文字列配列
  # ==== Return
  # none
  # ==== Raise
  # none
  def set_word(word)
    word = Word.find_or_create_by(text: word)
    self.word_id = word.id

    # HACK:重複のvalidateするのが望ましい
  end

end
