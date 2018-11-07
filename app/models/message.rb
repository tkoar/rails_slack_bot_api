class Message < ApplicationRecord
  belongs_to :user
  has_many :edit_histories
end
