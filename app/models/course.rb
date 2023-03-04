class Course < ApplicationRecord
  acts_as_list scope: [:week]

  has_many :chapters, -> { order(position: :asc) }, dependent: :destroy
  has_one :thumbnail, as: :thumbnailable, inverse_of: :thumbnailable
  has_many :agencies_courses
  has_many :agencies, through: :agencies_courses
  has_many :users_courses
  has_many :users, through: :users_courses
  has_many :favorite_courses, dependent: :destroy
  has_many :favorited_users, through: :favorite_courses, class_name: 'User', source: :user

  accepts_nested_attributes_for :thumbnail,
    reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true
  validates :resource_type, presence: true

  scope :by_position, -> { order(position: :asc) }
  scope :order_by_title, -> { order(title: :asc) }

  scope :non_coaching, -> { where(show_on_recording: false) }
  scope :show_on_recording, -> { where(show_on_recording: true) }

  scope :acadamics_fulfilment_program, (lambda do
    where(video_category_type: [:acadamics, :fulfilment])
  end)
  scope :fulfilment_program, (lambda do
    where(video_category_type: [:fulfilment])
  end)
  scope :start_agency_with_recording, (lambda do
    where(video_category_type: [:start_agency, :start_agency_recording])
  end)

  enum tier: %i[free starter pro advanced]
  enum resource_type: %i[agency business admin]
  enum video_category_type: %i[
    acadamics scale_program fulfilment start_agency start_agency_recording
  ]

  delegate :file_url, to: :thumbnail, allow_nil: true, prefix: true

  COACHING_CALL_TITLE = 'Coaching Calls'

  after_save do
    if week? && ! ScaleProgramHeader.exists?(week: week)
      ScaleProgramHeader.create(week: week, name: "Pillar #{week}")
    end
    if week.nil? && video_category_type == 'scale_program'
      self.update_column(:video_category_type, 'acadamics')
    elsif week.present? && video_category_type != 'scale_program'
      self.update_column(:video_category_type, 'scale_program')
    end
  end

  def permitted_resources
    resource_type.classify.constantize.where(id: permitted_resources_ids)
  end

  def progress(user)
    watched = WatchHistory.where({user: user, course: self}).count
    chapters_count = chapters.size.to_f
    return 0 if watched == 0 || chapters_count == 0
    user_progress = ((watched/chapters_count).round(2) * 100).to_i
    return 100 if user_progress >= 100
    user_progress
  end

  def challenge_progress(user, challenge_id)
    chapter_lists = chapters.where(course_challenge_id: challenge_id)
    watched = WatchHistory.where({user: user, course: self, chapter_id: chapter_lists.pluck(:id)}).count
    chapters_count = enable_challenge ? chapter_lists.size.to_f : chapters.size.to_f
    return 0 if watched == 0 || chapters_count == 0
    user_progress = ((watched/chapters_count).round(2) * 100).to_i
    return 100 if user_progress >= 100
    user_progress
  end

  def next(week)
    Course.where("week > ?", week).first
  end

  def prev(week)
    Course.where("week < ?", week).last
  end

  def prev_course(id)
    Course.where("id < ?", id).last
  end
end
