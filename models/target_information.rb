class TargetInformation < ActiveRecord::Base
  def self.search(param)
    if param
      target_information = TargetInformation.all
      target_information = target_information.where(['id = ?', param[:id]]) if param[:id].present?
      target_information = target_information.where(['name = ?', param[:name]]) if param[:name].present?
      target_information = target_information.where(['domain = ?', param[:domain]]) if param[:domain].present?
      target_information = target_information.where(['favicon_url LIKE ?', "%#{param[:favicon_url]}%"]) if param[:favicon_url].present?
      return target_information
    else
      return TargetInformation.all
    end
  end
end
