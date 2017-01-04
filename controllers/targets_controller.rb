class TargetsController < PrivateController

  def index
    # 返却 targetのモデル配列を返す
    @targets = Target.search(params[:target])

    # 検索フォーム用
    # 検索条件指定時
    @target = Target.new(params.require(:target).permit(:id, :target_information_id, :format, :url)) if params[:target].present?

    # 検索条件省略時
    @target = Target.new if !params[:target].present?
  end

  # def index
  #   # 入力欄を出す
  #   @target = Target.new()
  # end
  #
  # def new
  #   # 登録する
  #   @target = Target.new(params.require(:target).permit(:id, :target_information_id, :format, :url))
  #
  #   if @target.save
  #     #保存されたら @targetの詳細画面にリダイレクト
  #     redirect_to controller: 'targets', action: 'index'
  #   else
  #     render 'not saved'
  #   end
  #
  # end

  def new
    @target = Target.new()
  end

  def create
    # 登録する
    @target = Target.new(params.require(:target).permit(:id, :target_information_id, :format, :url))

    if @target.save
      #保存されたら @targetの詳細画面にリダイレクト
      redirect_to controller: 'targets', action: 'index'
    else
      render 'not saved'
    end
  end

  #def show
  #  paramId = params[:id]
  #  render :text => "show!#{paramId}"
  #end

  def edit
    # 入力欄を出す
    @target = Target.find(params[:id])
  end

  def update
    target = Target.find(params[:target][:id])
    target.target_information_id = params[:target][:target_information_id]
    target.format = params[:target][:format]
    target.url = params[:target][:url]
    if target.save
      redirect_to action: 'index'
    else
      render 'not saved'
    end
  end

  def destroy
    target = Target.find(params[:id])
    target.destroy
    redirect_to action: 'index'
  end

end
