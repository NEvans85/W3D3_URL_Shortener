require 'securerandom'

class ShortenedUrl < ApplicationRecord

  validates :short_url, uniqueness: true, presence: true
  validates :user_id, :long_url, presence: true

  has_many :visits,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: 'Visit'

  has_many :visitors,
    through: :visits,
    source: :visitor

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
  end

  def num_clicks
    Visit.where(shortened_url_id: id).length
  end

  def num_uniques
    Visit.select(:user_id).distinct.length
  end

  def num_recent_uniques
    Visit.select(:user_id).distinct.where(created_at: > 10.minutes.ago)
  end

end
