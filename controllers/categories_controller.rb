class CategoriesController < PrivateController
  def index
    # 返却 categoryのモデル配列を返す
    @categories = Category.search(params[:category])
    # 検索フォーム用
    # 検索条件指定時
    @category = Category.new(params.require(:category).permit(:id, :name)) if params[:category].present?
    # 検索条件省略時
    @category = Category.new if !params[:category].present?
  end

  def new
    @category = Category.new()
  end

  def create
    # 登録する
    @category = Category.new(params.require(:category).permit(:id, :name))

    if @category.save
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
    @category = Category.find(params[:id])
  end

  def update
    category = Category.find(params[:id])
    category.name = params[:category][:name]
    if category.save
      redirect_to action: 'index'
    else
      render 'not saved'
    end
  end

  def destroy
    category = Category.find(params[:id])
    category.destroy
    redirect_to action: 'index'
  end
end
