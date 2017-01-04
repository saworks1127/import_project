class WordsController < PrivateController
  def index
    @words = Word.search(params[:word])
    @word = Word.new(params.require(:word).permit(:text)) if params[:word].present?
    @word = Word.new if !params[:word].present?
  end

  def new
    @word = Word.new()
  end

  def create
    # 登録する
    @word = Word.new(params.require(:word).permit(:text))

    if @word.save
      #保存されたら @targetの詳細画面にリダイレクト
      redirect_to action: 'index'
    else
      render 'not saved'
    end
  end

  def edit
    @word = Word.find(params[:id])
  end

  def update
    word = Word.find(params[:id])
    word.text = params[:word][:text]
    if word.save
      redirect_to action: 'index'
    else
      render 'not saved'
    end
  end

  def destroy
    word = Word.find(params[:id])
    word.destroy
    redirect_to action: 'index'
  end
end
