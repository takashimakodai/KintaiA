class BasesController < ApplicationController
  def index
    @bases = Base.all
  end
  
  def show
  end
  
  def new
    @base = Base.new 
  end
  
  def create
    @base = User.new(params[:base_params])
    if @base.save
      flash[:success] = '登録に成功しました。'
      redirect_to @base
    else
      redirect_to new
    end
  end
  
  def edit
    @base = Base.find(params[:id])
  end
  
  def update
    @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
      flash[:success] = '情報を更新しました。'
      redirect_to basis_path
    else
      render :edit
      flash[:danger] = '入力して下さい'
    end
  end

  def destroy
    @base = Base.find(params[:id])
    @base.destroy
    flash[:success] = "#{@base.base_name}のデータを削除しました。"
    redirect_to basis_path
  end
  
  private
  
    def base_params
      params.require(:base).permit(:base_number, :base_name, :base_category)
    end  
end
