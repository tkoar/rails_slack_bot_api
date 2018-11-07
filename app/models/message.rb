class Message < ApplicationRecord
  belongs_to :user
  belongs_to :channel
  has_many :edit_histories
end
