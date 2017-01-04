# Article構築
#  Author:: himeno
#  Date::   2016/10/01

class ArticleConstructor

  # インスタンス化
  # ==== Args
  # target :: (Target)articleの親target
  # ==== Return
  # none
  # ==== Raise
  # none  
  def initialize(target)
    @target = target
  end

  # rssからarticleを生成
  # ==== Args
  # rss_item :: (RssItem)rss１記事
  # ==== Return
  # none
  # ==== Raise
  # none
  def build_from_rss_item(rss_item)
    article = Article.new()
    article.content = build_content(rss_item.title, rss_item.url, rss_item.published_date)

    # 新規レコードでなければこの時点で抜ける
    if !article.content.new_record?
      return article
    end

    # HACK : 分岐の削除（reject_ifをappendixに設定する）
    thumbnail_url = rss_item.get_thumbnail_url()
    if thumbnail_url.present?
      article.content.appendixes.build().set_thumbnail(thumbnail_url)
    end

    eyecatch_url = rss_item.get_eyecatch_url()
    if eyecatch_url.present?
      article.content.appendixes.build().set_eyecatch(eyecatch_url)
    end

    # タグ
    # HACK:別バッチ化の検討（処理負荷が高い可能性がある）
    tag_texts = rss_item.get_tags()
    tag_texts.each{|text|
      article.content.tags.build().set_word(text)
      # 重複あると落ちる →　validation　？？
    }

    return article
  end

  # content保存
  # ==== Args
  # none
  # ==== Return
  # none
  # ==== Raise
  # none
  private def build_content(title, url, published_date)
    content = Content.find_or_initialize_by(target_id: @target.id, text: url)
    if !content.new_record?
      # 既存の場合、更新しない
      return content
    end
    content.title = title
    content.category_id = 0           # HACK:カテゴリ適用
    content.published_date = published_date
    return content
  end

  # 既存contentからのArticle取得
  # ==== Args
  # (Content)既存のcontent
  # ==== Return
  # (Article)article
  # ==== Raise
  # none
  def self.build_from_content(content)
    article = Article.new()
    article.content = content
    article.thumbnail = content.appendixes.find_by(type: Appendix::types[:THUMBNAIL])
    article.eyecatch = content.appendixes.find_by(type: Appendix::types[:EYECATCH])
    return article
  end

end