class Category < ActiveRecord::Base
  def self.search(param)
    if param then
      category = Category.all
      category = category.where(['id = ?', param[:id]]) if param[:id].present?
      category = category.where(['name collate utf8_unicode_ci LIKE ?', "%#{param[:name]}%"])  if param[:name].present?
    else
      category = Category.all
    end
    return category
  end
end
