class Micropost < ApplicationRecord
  belongs_to :user
  scope :sort_by_created_at, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
            length: {maximum: Settings.micropost_maximum_length_content}
  validate :picture_size
  scope :find_ids, ->(following_ids, user_id){where("user_id IN (?) OR user_id = ?", following_ids, user_id)}
  def picture_size
    return if picture.size < Settings.picture_size.megabytes
    errors.add(:picture, Settings.error_image_size)
  end
end
