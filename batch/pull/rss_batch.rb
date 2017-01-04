# RSS取得バッチ処理
#  Author:: himeno
#  Date::   2016/09/01
#  Execute:: rails runner RssBatch.execute

require 'rss'

class RssBatch < BatchBase
  @@batch_description = 'RSS取得'

  # RSS取得・保存処理
  def self.main_task
    execDate = DateTime.now
    targets = Target.all
    targets.each do |target|
      begin
        rss = RSS::Parser.parse(target.url, true)
        Rails.logger.info 'Fetch success : ' + target.url
        p 'Fetch success : ' + target.url
      rescue => e
        #取得不能なURLはスキップ
        Rails.logger.info 'Fetch failed  : ' + target.url
        p 'Fetch failed  : ' + target.url
        p e
        next
      end

      rss.items.each do |item|
        begin
          rss_item = RssItem.new(item)
          article_constructor = ArticleConstructor.new(target)
          article = article_constructor.build_from_rss_item(rss_item)
          article.save()
        rescue ActiveRecord::RecordNotUnique
          # 重複エラー無視
          # HACK:validateするのが望ましい
        end
      end

      @@complete_count += 1
    end
    
    Rails.logger.info 'complete : ' + @@complete_count.to_s + ' targets'
  end
end
