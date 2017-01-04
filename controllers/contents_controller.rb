class ContentsController < PrivateController
  def index
    # 返却 contentのモデル配列を返す
    @contents = Content.search(params[:content])
    # 検索フォーム用
    # 検索条件指定時
    @content = Content.new(params.require(:content).permit(:id, :target_id, :type, :title, :text, :category_id, :published_date )) if params[:content].present?
    # 検索条件省略時
    @content = Content.new if !params[:content].present?
  end

  def new
    @content = Content.new()
  end

  def create
    # 登録する
    @content = Content.new(params.require(:content).permit(:id, :target_id, :type , :title , :text, :category_id, :published_date ))

    if @content.save
      #保存されたら @targetの詳細画面にリダイレクト
      redirect_to action: 'index'
    else
      render 'not saved'
    end
  end

  # def show
  #   paramId = params[:id]
  #   render :text => "show!#{paramId}"
  # end

  def edit
    @content = Content.find(params[:id])
  end

  def update
    content = Content.find(params[:id])
    content.target_id = params[:content][:target_id]
    content.type = params[:content][:type]
    content.title = params[:content][:title]
    content.text = params[:content][:text]
    content.category_id = params[:content][:category_id]
    content.published_date = params[:content][:published_date]
    if content.save
      redirect_to action: 'index'
    else
      render 'not saved'
    end
  end

  def destroy
    content = Content.find(params[:id])
    content.destroy
    redirect_to action: 'index'
  end
end
