class TargetInformationsController < PrivateController

  def index
    # 返却 targetのモデル配列を返す
    @target_informations = TargetInformation.search(params[:target_information])
    @temp = params[:target_information]

    # 検索フォーム用
    # 検索条件指定時
    @target_information = TargetInformation.new(params.require(:target_information).permit(:id, :name, :domain, :favicon_url)) if params[:target_information].present?

    # 検索条件省略時
    @target_information = TargetInformation.new if !params[:target_information].present?
  end

  def new
    # 入力欄を出す
    @target_information = TargetInformation.new()
  end

  def create
    # 登録する
    @target_information = TargetInformation.new(params.require(:target_information).permit(:id, :name, :domain, :favicon_url))

    if @target_information.save
      #保存されたら一覧画面にリダイレクト
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
    # 入力欄を出す
    @target_information = TargetInformation.find(params[:id])
  end

  def update
    targetInformation = TargetInformation.find(params[:target_information][:id])
    targetInformation.name = params[:target_information][:name]
    targetInformation.domain = params[:target_information][:domain]
    targetInformation.favicon_url = params[:target_information][:favicon_url]
    if targetInformation.save
      redirect_to action: 'index'
    else
      render 'not saved'
    end
  end

  def destroy
    targetInformation = TargetInformation.find(params[:id])
    targetInformation.destroy
    redirect_to action: 'index'
  end
end
