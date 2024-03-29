# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :unit
  has_many :activity_histories, dependent: :destroy
  has_many :training_activities, through: :activity_histories

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :uid, allow_blank: true, presence: true, uniqueness: { scope: :provider }
  validates :provider, presence: true
end
