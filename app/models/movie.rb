class Movie < ActiveRecord::Base

  has_many :reviews

  mount_uploader :poster_image_url, PosterImageUrlUploader


  validates :title, :director, :description, :release_date, :poster_image_url,
    presence: true

  # validates :director,
  #   presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  # validates :description,
  #   presence: true

  # validates :poster_image_url,
  #   presence: true

  # validates :release_date,
  #   presence: true

  validate :release_date_is_in_the_past

  def review_average
    if reviews.size < 1
      "There are no reviews yet for this movie" #{title}"
    else
      avg = "#{reviews.sum(:rating_out_of_ten)/reviews.size}/10"
    end
  end

  scope :search_term, ->(search) {
    where('title LIKE ? OR director LIKE ?', "%#{search}%", "%#{search}%")
  }

  scope :runtime, ->(runtime_in_minutes) {where("runtime_in_minutes BETWEEN #{runtime_in_minutes}")}

  # def self.search(search, runtime_in_minutes)
  #   if runtime_in_minutes and !search.empty? 
  #     where('title LIKE ? OR director LIKE ?', "%#{search}%", "%#{search}%").where("runtime_in_minutes BETWEEN #{runtime_in_minutes}")#.where('director = ?', "%#{search_dir}%").where("runtime_in_minutes BETWEEN #{runtime_in_minutes}")
  #   elsif runtime_in_minutes and search.empty?
  #     where("runtime_in_minutes BETWEEN #{runtime_in_minutes}")#.where('director = ?', "%#{search_dir}%").where("runtime_in_minutes BETWEEN #{runtime_in_minutes}")
  #   end
  # end



  protected

  def release_date_is_in_the_past
    if release_date.present?
      errors.add(:release_date, "should be in the past") if release_date > Date.today
    end
  end

end