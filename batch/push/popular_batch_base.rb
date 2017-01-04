# （日次）自動投稿バッチ処理
#  Author:: himeno
#  Date::   2016/09/20

class PopularBatchBase < BatchBase
  @@article_count = 10
  @@blog_url = ''
  @@user = ''
  @@password = ''
  @@categories = nil
  @@keywords = nil

  def self.main_task
    #記事本文
    description = create_description

    #投稿
    PostBlog.post(@@blog_url,
                  @@user,
                  @@password,
                  Date.today.to_s + 'の人気記事',
                  description,
                  @@categories,
                  @@keywords)
  end

  def self.create_description
    raise "discriptionを返すメソッドを定義してください。"
  end

end
