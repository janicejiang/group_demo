class Group < ApplicationRecord
  validates :title, presence: true

  belongs_to :user # 1对1 belongs_to 关联声明中必须使用单数形式
  has_many :posts
  has_many :group_relationships
  has_many :members, through: :group_relationships, source: :user
end
