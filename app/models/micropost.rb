class Micropost < ApplicationRecord
  belongs_to :user
  scope :sort_by_created_at, ->{order created_at: :desc}
  scope :find_ids, ->(ids){where "user_id = ?", ids}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
            length: {maximum: Settings.micropost_maximum_length_content}
  validate :picture_size

  private

  def picture_size
    check = picture.size > Settings.picture_size.megabytes
    error = errors.add(:picture, Settings.error_image_size)
    return error if check
  end
end
