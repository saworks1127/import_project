# Rss１記事要素モデル
#  Author:: himeno
#  Date::   2016/10/01

class RssItem

  # 定数
  GOOGLE_NEWS_DOMAIN = 'news.google.com'
  GOOGLE_THUMBNAIL_PREFIX = "<img src=\""
  GOOGLE_THUMBNAIL_SUFFIX = "\" alt"
  IMAGE_URI_SCHEMES = ["http", "https"]   # HACK:微妙

  # 要素
  attr_reader :base_rss_item
  attr_reader :title
  attr_reader :url
  attr_reader :description
  attr_reader :published_date

  # インスタンス化
  # ==== Args
  # item :: (RSS::Rss::Channel::Item)rssの１要素
  # ==== Return
  # none
  # ==== Raise
  # none  
  def initialize(item)
    # HACK:クラスチェック、違ったらraise。rdfの場合注意
    @base_rss_item = item

    @title = item.title
    @description = item.description

    if item.link.include?(GOOGLE_NEWS_DOMAIN)
      # Google News
      @url = item.link.split('&url=')[1]                                # 記事URLは（&url=）以降から取得し設定
    else
      # 一般サイト
      @url = item.link                                          # 記事URLを設定
    end

    if item.respond_to?(:pubDate) && item.pubDate.present?
      @published_date = item.pubDate
    else
      @published_date = DateTime.now  # 発行日時がない場合の代替
    end
  end

  # thumbnail画像urlの取得
  # （一般サイト用）
  # ==== Args
  # description :: rss.item.description
  # ==== Return
  # image_uri :: thumbnail画像url
  # ==== Raise
  # none
  private def parse_image_url(description)
    if description.blank?
      return ''
    end

    if @base_rss_item.link.include?(GOOGLE_NEWS_DOMAIN) 
      return ''
    end

    image_uri = ''
    # HACK:複数画像をもつ場合、どの画像が適切か判断すべき
    URI.extract(description, IMAGE_URI_SCHEMES).each do |uri|
      # HACK:拡張子の定数化　ここ配列で渡せないからどうする・・・？
      if uri.end_with?("jpeg", "jpg", "png", "gif")
        image_uri = uri
        break
      elsif uri.include?(".flv.mp4")
        image_uri = uri.tr!("\'", "")
        break
      end
    end
    return image_uri
  end

  # thumbnail画像urlの取得
  # （Google News用）
  # ==== Args
  # description :: rss.item.description
  # ==== Return
  # image_uri :: thumbnail画像url
  # ==== Raise
  # none
  private def parse_goole_news_thumbnail(description)
    if description.blank?
      return ''
    end

    if !@base_rss_item.link.include?(GOOGLE_NEWS_DOMAIN) 
      return ''
    end

    image_uri = ''
    url_arr = /#{GOOGLE_THUMBNAIL_PREFIX}.*#{GOOGLE_THUMBNAIL_SUFFIX}/.match(description)
    if url_arr.present? && url_arr[0].present?
      url_text = url_arr[0]
      url_text = url_text.gsub(GOOGLE_THUMBNAIL_PREFIX, '')
      url_text = url_text.gsub(GOOGLE_THUMBNAIL_SUFFIX, '')
      image_uri = 'http:' + url_text
    end
    return image_uri
  end

  # サムネイル画像
  # ==== Args
  # (String) :: 画像URL
  # ==== Return
  # none
  # ==== Raise
  # none
  def get_thumbnail_url()
    return parse_goole_news_thumbnail(@base_rss_item.description)     # サムネイルのみ、アイキャッチなし
  end

  # アイキャッチ画像
  # ==== Args
  # (String) :: 画像URL
  # ==== Return
  # none
  # ==== Raise
  # none
  def get_eyecatch_url()
    return parse_image_url(@base_rss_item.description)         # アイキャッチのみ、サムネイルなし
  end

  # タグ配列
  # ==== Args
  # (Array) :: 文字列配列
  # ==== Return
  # none
  # ==== Raise
  # none
  def get_tags()
    tags = []
    Natto::MeCab.new.parse(@title) do |node|
      meta = node.feature.split(',')
      if meta[0].include?('名詞') && meta[1].include?('固有名詞')
        #固有名詞のみタグとして保存
        tags.push(node.surface)
      end
    end
    return tags
  end

end