#  XML-RPC連携投稿処理
#  Author:: himeno
#  Date::   2016/09/20

require 'xmlrpc/client'

class PostBlog

  # 投稿処理
  # ==== Args
  # url         :: 投稿先ブログurl
  # user        :: user
  # password    :: password
  # title       :: タイトル
  # description :: 本文
  # categories  :: カテゴリ配列
  # keywords    :: キーワード配列
  # ==== Return
  # none
  # ==== Raise
  # none
  def self.post(url, user, password, title, description, categories, keywords)
    # 投稿データ
    struct = {
      'title'       => title,         # タイトル
      'description' => description,   # 本文
      'categories'  => categories,    # カテゴリ配列
      'mt_keywords' => keywords       # キーワード配列
    }

    # 投稿処理
    id = XMLRPC::Client.new2(url + '/xmlrpc.php').call(
      "metaWeblog.newPost",   # 投稿プロシージャ名
      1,                      # ブログID　TODO:確認方法の調査
      user,                   # user
      password,               # password
      struct,                 # 投稿データ
      1                       # 投稿区分（0:下書き, 1:投稿）
    )

    Rails.logger.info "PostID: #{id}"
    p "PostID: #{id}"
  end
end
