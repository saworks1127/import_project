# （毎時）overwatch　ブログ投稿バッチ処理
#  Author:: himeno
#  Date::   2016/09/20
#  Execute:: rails runner PostHourlyOverWatch.execute

class EveryOverWatch < EveryBatchBase
  @@batch_description = 'OverWatchブログ 毎時投稿'
  @@blog_url = 'https://omnic.wordpress.com'
  @@user = Rails.application.secrets.omnic_user
  @@password = Rails.application.secrets.omnic_password
  @@categories = ['OVERWATCH', '最新記事']
  @@keywords = ['OVERWATCH', 'オーバーウォッチ']

  def self.one_hour_contents
    #１時間以内の記事を取得
    contents = Content.contain_tags(@@keywords).within_one_hour
    return contents
  end

  def self.create_description(content)
    # 投稿用画像取得
    article = ArticleConstructor.build_from_content(content)
    appendix = article.image('https://pbs.twimg.com/profile_images/750599382647578624/Z0DsSnik.jpg')

    # 投稿投稿内容の生成
    description = ''
    description << "<a href=\"#{content.text}\" target=\"_blank\">"
    description << image_description(appendix.text)
    description << "#{content.title}"
    description << "</a>"
    return description
  end

  def self.image_description(image_path)
    return "<img class=\"alignnone size-full wp-image-80 aligncenter\" src=\"#{image_path}\" alt=\"gazou_0178\" width=\"300\"/>"
  end

end
