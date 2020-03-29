class BasesController < ApplicationController
  def index
    @bases = Base.all
    
  end
  
  def show
    @base = Base.find(params[:id])
  end
  
  def new
    @base = Base.new 
  end
  
  def create
    @base = User.new(params[:base_params])
    if @base.save
      
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
  end

  def destroy
  end
  
  private
  
    def base_params
      params.require(:base).permit(:base_number, :base_name, :base_category)
    end  
end
