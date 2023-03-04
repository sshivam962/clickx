class Chapter < ApplicationRecord
  belongs_to :course
  acts_as_list scope: :course
  has_many :action_steps, -> { order(position: :asc) },  dependent: :destroy

  has_many :file_attachments, as: :file_attachable, dependent: :destroy

  accepts_nested_attributes_for :file_attachments,
                                reject_if: :all_blank,
                                allow_destroy: true

  validates :title, presence: true
  validates :video_embed_code, presence: true

  def update_watch_history user
    wc = user.watch_histories.find_or_create_by(chapter: self, course: course)
    wc.last_seen = Time.now
    wc.save
  end
end
