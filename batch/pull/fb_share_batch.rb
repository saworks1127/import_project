# FBシェア数取得バッチ処理
#  Author::  himeno
#  Date::    2016/09/01
#  Execute:: rails runner FbShareBatch.execute

class FbShareBatch < BatchBase
  @@batch_description = 'FBシェア数取得'
  @@wait_second = 1
  @@retry_count = 0

  # FBシェア数取得・保存処理
  def self.main_task
    @@complete_count = 0
    exec_date = DateTime.now
    contents = Content.all.order(published_date: :desc)
    contents.each do |content|
      # contentのシェア数更新
      if ContentFbShare.build(content.id).update()
        Rails.logger.info "target  : " + content.text
        @@complete_count += 1
        wait_interval
      end
    end

    Rails.logger.info 'complete : ' + @@complete_count.to_s + ' contents'
  end

  # 指定秒数待機
  def self.wait_interval
    Rails.logger.debug 'waiting ' + @@wait_second.to_s + ' second ...'
    sleep @@wait_second
  end

end
