class ShortenedUrl < ActiveRecord::Base

  validates :short_url, presence: true, uniqueness: true, length: { maximum: 1024 }
  validates :long_url, presence: true, uniqueness: true, length: { maximum: 1024 }
  validates :submitter_id, presence: true

  def self.random_code
    code = SecureRandom.urlsafe_base64 until code && !exists?(short_url: code)
    code
  end

  def self.create_for_user_and_long_url!(user, long_url)
    if user.valid?
      s = ShortenedUrl.new(submitter_id: user.id, long_url: long_url, short_url: random_code)
      s.save!
      s
    end
  end

  def self.find_most_popular(category)
    sql = <<-SQL
      SELECT
        s.*
      FROM
        shortened_urls as s
      JOIN taggings
        ON s.id = taggings.shortened_url_id
      JOIN tag_topics
        ON taggings.tag_topic_id = tag_topics.id
      JOIN visits
      ON visits.url_id = s.id
      GROUP BY
        s.id, tag_topics.topic
      ORDER BY
        COUNT(visits.id) DESC
      LIMIT
        1
    SQL

    find_by_sql([sql, category]).first
  end

  belongs_to(
    :submitter,
    class_name: 'User',
    foreign_key: :submitter_id,
    primary_key: :id
  )

  has_many(
    :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :user
  )

  has_many(
    :visits,
    class_name: 'Visit',
    foreign_key: :url_id,
    primary_key: :id
  )

  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

  has_many(
    :tag_topics,
    through: :taggings,
    source: :tag_topic
  )

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visitors.where("visits.updated_at >= ?", 10.minutes.ago).count
  end

end
