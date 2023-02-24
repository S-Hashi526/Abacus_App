class BasesController < ApplicationController
  before_action :set_base, only: [:show, :edit, :update, :destroy]

  # 管理者かどうか
  before_action :admin_user, only: [:index, :show, :new, :edit, :update]
  
  def index
    @bases = Base.all
  end

  def show
  end

  def new
    @base = Base.new
  end

  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = "#{@base.base_name}の拠点情報を追加しました。"
      redirect_to bases_url
    else
      flash[:danger] = "拠点情報を追加できませんでした。"
      render :index
    end
  end

  def edit
  end

  def update
    if @base.update_attributes(base_params)
      flash[:success] = "#{@base.base_name}の拠点情報が更新されました。"
      redirect_to bases_url
    else
      render :edit
    end
  end

  def destroy
    @base.destroy
    flash[:success] = "#{@base.base_name}を削除しました。"
    redirect_to bases_url
  end

  private

    def base_params
      params.require(:base).permit(:base_number, :base_name, :attendance_type)
    end

    def set_base
      @base = Base.find(params[:id])
    end

end