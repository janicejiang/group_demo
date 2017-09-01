class Group < ApplicationRecord
  validates :title, presence: true

  belongs_to :user # 1对1 belongs_to 关联声明中必须使用单数形式
end
