class Tagging < ActiveRecord::Base

  def self.tag_url!(tag_topic, shortened_url)
    Tagging.new(tag_topic_id: tag_topic.id, shortened_url_id: shortened_url.id).save!
  end

  belongs_to(
    :tag_topic,
    class_name: 'TagTopic',
    foreign_key: :tag_topic_id,
    primary_key: :id
  )

  belongs_to(
    :shortened_url,
    class_name: 'ShortenedUrl',
    foreign_key: :shortened_url_id,
    primary_key: :id
  )

end
