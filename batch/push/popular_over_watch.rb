# （日次）overwatchブログ投稿バッチ処理
#  Author:: himeno
#  Date::   2016/09/20
#  Execute:: rails runner PostOverWatch.execute

class PopularOverWatch < PopularBatchBase
  @@batch_description = 'OverWatchブログ 投稿'
  @@blog_url = 'https://omnic.wordpress.com'
  @@user = Rails.application.secrets.omnic_user
  @@password = Rails.application.secrets.omnic_password
  @@categories = ['OVERWATCH','人気記事ランキング']
  @@keywords = ['OVERWATCH', 'オーバーウォッチ']

  def self.create_description
    cnt = 0
    description = '<table>'
    #２４時間以内の人気記事順を取得
    contents = Content.contain_tags(@@keywords).today_ranking.limit(@@article_count)
    contents.each do |content|
      cnt += 1
      
      # 投稿用画像取得
      article = ArticleConstructor.build_from_content(content)
      appendix = article.image('https://pbs.twimg.com/profile_images/750599382647578624/Z0DsSnik.jpg')

      # 投稿投稿内容の生成
      description << "<tr><td><a href=\"#{content.text}\" target=\"_blank\">"
      description << image_description(appendix.text)
      description << "#{content.title}"
      description << "</a></td></tr>"
    end
    description << "</table>"
    Rails.logger.debug description
    return description
  end

  def self.image_description(image_path)
    return "<img class=\"alignnone size-full wp-image-80 aligncenter\" src=\"#{image_path}\" alt=\"gazou_0178\" align=\"left\" width=\"100\"/>"
  end
end
