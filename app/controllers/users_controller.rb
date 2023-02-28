class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :list_of_employees]
  # ログイン中のユーザーか
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  # アクセス先のログインユーザー
  before_action :correct_user, only: [:edit, :update, :edit_basic_info, :update_basic_info, :edit_basic_info, :update_basic_info]
  # 管理者ユーザー
  before_action :admin_user, only: [:destroy, :index, :list_of_employees, :edit_basic_info, :update_basic_info]
  # 1か月分の勤怠情報を取得
  before_action :set_one_month, only: :show
  # アクセス先のログインユーザーor上長（管理者も不可）
  before_action :admin_or_correct_user, only: :show

  def index
    @users = User.paginate(page: params[:page])
    @users = @users.where('name like ?', "%#{params[:search]}%") if params[:search].present?
  end

  def import
    if params[:file].blank?
      flash[:danger]= "csvファイルを選択してください"
    else 
      User.import(params[:file]) 
      flash[:success] = "csvファイルをインポートしました"    
    end
    redirect_to users_url
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count    
    @superior = User.where(superior: true).where.not(id: @user.id)
    @attendance = @user.attendances.find_by(worked_on: @first_day)
   # @user.attendancesは、Attendance.find_by(user_id: @user.id)
    if current_user.superior?      
      @overwork_sum = Attendance.includes(:user).where(superior_confirmation: current_user.id, overwork_status: "申請中").count
      @attendance_change_sum = Attendance.includes(:user).where(superior_attendance_change_confirmation: current_user.id, attendance_change_status: "申請中").count
      @one_month_approval_sum = Attendance.includes(:user).where(superior_month_notice_confirmation: current_user.id, onemonth_approval_status: "申請中").count    
    end
    # csv出力
    respond_to do |format|
      format.html
        # html用の処理を記述
      format.csv do |csv|
        # csv用の処理を記述
        send_attendances_csv(@attendances)
      end
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    end
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "アカウント情報を更新しました。"
    else
      flash[:danger] = "アカウント情報を更新できません。"
    end
    redirect_to edit_user_url
  end

  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "社員情報を更新しました。"
    else
      flash[:danger] = "社員情報を更新できません。"     
    end
    redirect_to users_url
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def working_list
    @users = User.all.includes(:attendances)
  end

  def confirmation
  end
  
  private
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def basic_info_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end
    

    def send_attendances_csv(attendances)
      # 文字化け防止
      bom = "\uFEFF"
      # CSV.generateとは、対象データを自動的にCSV形式に変換してくれるCSVライブラリの一種
      csv_data = CSV.generate(bom, encoding: Encoding::SJIS, row_sep: "\r\n", force_quotes: true) do |csv|
        # %w()は、空白で区切って配列を返します
        column_names = %w(日付 曜日 出勤時間 退勤時間)
        # csv << column_namesは表の列に入る名前を定義します。
        csv << column_names
        # column_valuesに代入するカラム値を定義します。
        @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
        @attendances.each do |day|
          column_values = [
            l(day.worked_on, format: :short),
            $days_of_the_week[day.worked_on.wday],
            if day.started_at.present? && (day.attendance_change_status == "承認").present?
              l(day.started_at.floor_to(60*15), format: :time)
            else
              ""
            end,
            if day.finished_at.present? && (day.attendance_change_status == "承認").present?
              l(day.finished_at.floor_to(60*15), format: :time)
            else
              ""
            end
          ]
        # csv << column_valuesは表の行に入る値を定義します。
          csv << column_values
        end
      end
      # csv出力のファイル名を定義します。
      send_data(csv_data, filename: "【勤怠一覧】#{@user.name}_#{@first_day.strftime("%Y-%m")}.csv", type: :csv)
    end
end