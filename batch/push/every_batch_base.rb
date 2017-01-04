# （毎時）自動投稿バッチ処理
#  Author:: himeno
#  Date::   2016/09/20

class EveryBatchBase < BatchBase

  # HACK:everyとpopularの共通ベースクラスの作成・メンバを移動させる
  @@blog_url = ''
  @@user = ''
  @@password = ''
  @@categories = nil
  @@keywords = nil

  def self.main_task
    # 記事取得
    contents = one_hour_contents
  
    #投稿
    contents.each do |content|
      texts = []
      content.words.each do |word|
        texts.push word.text
      end
      PostBlog.post(@@blog_url,
                    @@user,
                    @@password,
                    content.title,
                    create_description(content),
                    @@categories,
                    texts
                    )
    end
  end

  def self.one_hour_contents
    raise "contentsを返すメソッドを定義してください。"
  end

  def self.create_description(content)
    raise "discriptionを返すメソッドを定義してください。"
  end

end