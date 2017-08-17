require 'securerandom'

class ShortenedUrl < ApplicationRecord

  validates :short_url, uniqueness: true, presence: true
  validates :user_id, :long_url, presence: true

  has_many :visits,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: 'Visit'

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitor

  has_many :taggings,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: 'Tagging'

  has_many :tags,
    through: :taggings,
    source: :tag_topic

  def self.random_code
    SecureRandom.urlsafe_base64
  end

  def self.create!(user, long_url)
    short = ShortenedUrl.new({
                long_url: long_url,
                user_id: user.id,
                short_url: "http://www.#{ShortenedUrl.random_code}.com"
                })
    short.save!
    short
  end

  def num_clicks
    Visit.where(shortened_url_id: id).length
  end

  def num_uniques
    visitors.length
  end

  def num_recent_uniques
    visitors.where(created_at: (10.minutes.ago..0.minutes.ago)).length
  end

end
