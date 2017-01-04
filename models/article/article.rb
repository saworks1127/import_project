# Article
#  Author:: himeno
#  Date::   2016/09/01

class Article

  attr_accessor :content
  attr_accessor :thumbnail
  attr_accessor :eyecatch

  # 保存
  # ==== Args
  # nont
  # ==== Return
  # none
  # ==== Raise
  # none
  def save()
    # content及び各appendixの保存
    @content.save()
  end

  # 投稿用画像取得
  # ==== Args
  # nont
  # ==== Return
  # (Appendix)記事の画像
  # ==== Raise
  # none
  def image(default_image_path)
    if @eyecatch.present?
      return @eyecatch
    elsif @thumbnail.present?
      return @thumbnail
    else
      return Appendix.new(text:default_image_path)
    end
  end

end