class TagTopic < ActiveRecord::Base

  has_many(
    :taggings,
    class_name: 'Tagging',
    foreign_key: :tag_topic_id,
    primary_key: :id
  )

  has_many(
    :shortened_urls,
    through: :taggings,
    source: :shortened_url
  )

  def self.most_popular_url(category)
    ShortenedUrl.find_most_popular(category)
  end

end
