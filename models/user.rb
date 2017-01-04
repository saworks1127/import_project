class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  # 表示用email
  # ==== Args
  # none
  # ==== Return
  # string 規定文字数＋'...'
  # ==== Raise
  # none
  def short_email
    return self.email[0,10]+'...'
  end
  
end
