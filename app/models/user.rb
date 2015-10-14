class User < ActiveRecord::Base
  validates :email, presence: true, uniqueness: true
  validate :max_submission?

  has_many(
    :submitted_urls,
    class_name: 'ShortenedUrl',
    foreign_key: :submitter_id,
    primary_key: :id
  )

  has_many(
    :visited_urls,
    through: :visits,
    source: :shortened_url
  )

  has_many(
    :visits,
    class_name: 'Visit',
    foreign_key: :user_id,
    primary_key: :id
  )

  def submitted_urls=(submitted_url)
    super unless !valid?
  end

  def max_submission?
    if submitted_urls.where("shortened_urls.updated_at <= ?", 1.minute.ago).count > 5
      errors.add(:submitted_urls, "can't be greater than 5 in the last minute")
    end
  end

end
