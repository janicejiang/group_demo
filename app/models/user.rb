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

  # participated_groups返回一个数组包含当前用户参加的所有小组实例
  # 对应的 SQLite SQL 语句如下:
  # SELECT "groups".* FROM "groups" INNER JOIN "group_relationships"
  # ON "groups"."id" = "group_relationships"."group_id"
  # WHERE "group_relationships"."user_id" = ?
  def is_member_of?(group)
    participated_groups.include?(group)
  end
  # 调用 Array#include?, 如果传进来的Group实例包含在 participated_groups 数组中, 则返回 true

  def join!(group)
    participated_groups << group
  end

  def quit!(group)
    participated_groups.delete(group)
  end
end
