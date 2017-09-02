class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :groups # 1对多 has_many 关联, 另一个模型使用复数形式
  has_many :posts
  has_many :group_relationships
  has_many :participated_groups, :through => :group_relationships,
                                 :source => :group

  def is_member_of?(group)
    # participated_groups 返回一个数组包含当前调用 is_member_of(group) 方法的用户参加的所有小组实例
    # 对应的 SQLite SQL 语句如下:
    # SELECT "groups".* FROM "groups" INNER JOIN "group_relationships"
    # ON "groups"."id" = "group_relationships"."group_id"
    # WHERE "group_relationships"."user_id" = ?

    participated_groups.include?(group)
    # 调用 Array#include?, 如果 group 变量包含在 participated_groups 数组中, 则返回 true
  end
end
