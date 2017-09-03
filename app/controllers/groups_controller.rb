class GroupsController < ApplicationController
  # :authenticate_user! 是 devise 提供的 helper, 限制使用者必须登入
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :join, :quit]
  before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id]) # find 方法检索指定主键对应的对象
    # @group.post 会返回一个数组包含该 group 的所有 posts
    @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    # 赋值关联的对象, @group.user 返回 current_user 对象
    # 数据库层面会把 current_user 的 id, 赋值给 @group 的 user_id
    @group.user = current_user

    if @group.save
      current_user.join!(@group)
      redirect_to groups_path # groups_path 辅助方法, 返回值为 /groups
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to groups_path, notice: "Update Success"
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    flash[:alert] = "Group deleted"
    redirect_to groups_path
  end

  def join
    @group = Group.find(params[:id])

    if !current_user.is_member_of?(@group)
      current_user.join!(@group)
      flash[:notice] = "加入本讨论版成功"
    else
      flash[:warning] = "你已经是本讨论版成员了!"
    end

    redirect_to group_path(@group)
  end

  def quit
    @group = Group.find(params[:id])

    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
      flash[:alert] = "已退出本讨论版!"
    else
      flash[:warning] = "你不是本讨论版成员，怎么退出 XD"
    end

    redirect_to group_path(@group)
  end

  private # private 方法在 GroupsController 内被调用

  def group_params
    params.require(:group).permit(:title, :description)
  end

  def find_group_and_check_permission
    @group = Group.find(params[:id])

    if current_user != @group.user
      redirect_to root_path, alert: "You have no permission."
    end
  end
end
