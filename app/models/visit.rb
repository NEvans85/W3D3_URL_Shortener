class Visit < ApplicationRecord
  validates :shortened_url_id, :user_id, presence: true

  belongs_to :visitor,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: 'User'

  belongs_to :visited_url,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: 'ShortenedUrl'

  def self.visit_record!(user, shortened_url)
    visit = Visit.new(shortened_url_id: shortened_url.id,
                      user_id: user.id)
    visit.save!
  end


end
