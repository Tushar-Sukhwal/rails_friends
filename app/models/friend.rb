class Friend < ApplicationRecord
  belongs_to :user
  
  # Validations
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, presence: true, 
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" },
                    uniqueness: { scope: :user_id, message: "has already been added to your friends" }
  validates :phone, format: { with: /\A[\d\s\-\+\(\)\.]+\z/, message: "must be a valid phone number" }, 
                    allow_blank: true,
                    length: { minimum: 10, maximum: 20 }
  validates :twitter, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "must contain only letters, numbers, and underscores" },
                      allow_blank: true,
                      length: { maximum: 15 }
  
  # Normalize data before validation
  before_validation :normalize_data
  
  private
  
  def normalize_data
    self.first_name = first_name.strip.capitalize if first_name.present?
    self.last_name = last_name.strip.capitalize if last_name.present?
    self.email = email.strip.downcase if email.present?
    self.twitter = twitter.strip.gsub(/^@/, '') if twitter.present? # Remove @ symbol if present
  end
end
