class TagTopic < ApplicationRecord
  validates :name, uniqueness: true, presence: true

  has_many :taggings,
    primary_key: :id,
    foreign_key: :tag_topic_id,
    class_name: 'Tagging'

  has_many :tagged_urls,
    through: :taggings,
    source: :shortened_url

  def popular_links
    self.tagged_urls.order()
  end
end
