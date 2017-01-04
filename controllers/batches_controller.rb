class BatchesController < ApplicationController
  def index
   #render :text => 'Hello!Batches'
  end

  def new
    render :text => 'new!'
  end

  def create
    render :text => 'create!?'
  end

  def show
    paramId = params[:id]
    render :text => "show!#{paramId}"
  end

  def edit
    render :text => 'edit!'
  end

  def update
    render :text => 'update!'
  end

  def destroy
    render :text => 'destroy!'
  end
end
