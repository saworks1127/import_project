class BatchBase
  @@batch_description = 'バッチ概要'
  @@date_format = '%Y/%m/%d %H:%M:%S'
  @@complete_count = 0

  # バッチ規定処理
  def self.execute
    begin
      log_before
      main_task
      log_after
    rescue Interrupt
      Rails.logger.info 'batch end by interrupt.'
    rescue => e
      Rails.logger.fatal e
      p e
    end
  end

  # バッチ開始ログ
  def self.log_before
    Rails.logger.info @@batch_description + ' 開始 : ' + DateTime.now.strftime(@@date_format)
  end

  # バッチ終了ログ
  def self.log_after
    Rails.logger.info @@batch_description + ' 終了 : ' + DateTime.now.strftime(@@date_format)
  end

  def self.main_task
    # Implement in inherited class
  end
end
