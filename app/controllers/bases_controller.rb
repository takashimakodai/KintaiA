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
  end

  def destroy
  end
  
  private
  
    def base_params
      params.require(:base).permit(:base_number, :base_name, :base_category, :user_id)
    end  
end
