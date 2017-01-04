# （毎時）erodouga　ブログ投稿バッチ処理
#  Author:: himeno
#  Date::   2016/12/01
#  Execute:: rails runner EveryEroDouga.execute

class EveryEroDouga < EveryBatchBase
  @@batch_description = 'EroDougaブログ 毎時投稿'
  @@blog_url = 'http://blog.fc2.com'
  @@user = Rails.application.secrets.erodouga_user
  @@password = Rails.application.secrets.erodouga_password
  @@categories = ['動画', '最新記事']
  @target_ids = [8] # http://ero-video.net/new_movie.rss

  def self.one_hour_contents
    #１時間以内の記事を取得
    contents = Content.where_target(@target_ids).within_one_hour
    return contents
  end

  def self.create_description(content)
    # 投稿用画像取得
    article = ArticleConstructor.build_from_content(content)
    appendix = article.image('http://blog-imgs-99.fc2.com/e/r/o/erodougamaxvideos/no_image.png')

    # 投稿投稿内容の生成
    description = ''
    description << "<p>"
    description << "<a href=\"#{content.text}\" target=\"_blank\">"
    description << image_description(appendix.text)
    description << "</p>"
    description << "<p>"
    description << embed_movie(content.text)
    description << "</p>"
    description << "<p>"
    description << "#{content.title}"
    description << "</p>"
    description << "</a>"
    return description
  end

  def self.image_description(image_path)
    return "<img class=\"alignnone size-full wp-image-80 aligncenter\" src=\"#{image_path}\" alt=\"gazou_0178\" width=\"300\"/>"
  end

  def self.embed_movie(url)
    uri = URI::parse(url)
    description = ''
    description << "<script type=\"text/javascript\" src=\"http://ero-video.net/js/embed_evplayer.js\"></script>"
    description << "<script type=\"text/javascript\">embedevplayer(\"#{uri.query}\", 450, 274);</script>"
    return description
  end

end
