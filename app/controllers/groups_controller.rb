class GroupsController < ApplicationController
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
    @group.save
    redirect_to groups_path # groups_path 辅助方法, 返回值为 /groups
  end

  private # private 在 GroupsController 内被调用

  def group_params
    params.require(:group).permit(:title, :description)
  end
end
