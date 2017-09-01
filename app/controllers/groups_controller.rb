class GroupsController < ApplicationController
  # :authenticate_user! 是 devise 提供的 helper, 限制使用者必须登入
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id]) # find 方法检索指定主键对应的对象
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    # 赋值关联的对象, @group.user 返回 current_user 对象
    @group.user = current_user

    if @group.save
      redirect_to groups_path # groups_path 辅助方法, 返回值为 /groups
    else
      render :new
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])

    if @group.update(group_params)
      redirect_to groups_path, notice: "Update Success"
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    flash[:alert] = "Group deleted"
    redirect_to groups_path
  end

  private # private 方法在 GroupsController 内被调用

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
