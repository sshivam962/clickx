class AddCourseChallengeIdToChapter < ActiveRecord::Migration[5.1]
  def change
    add_column :chapters, :course_challenge_id, :integer
  end
end
