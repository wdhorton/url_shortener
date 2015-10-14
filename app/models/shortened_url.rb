class ShortenedUrl < ActiveRecord::Base

  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true, uniqueness: true
  validates :submitter_id, presence: true

  def self.random_code
    code = SecureRandom.urlsafe_base64 until code && !exists?(short_url: code)
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.new(submitter_id: user.id, long_url: long_url, short_url: random_code).save!
  end

  belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :submitter_id,
    primary_key: :id
  
  )
end
