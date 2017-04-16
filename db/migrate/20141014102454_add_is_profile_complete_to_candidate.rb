class AddIsProfileCompleteToCandidate < ActiveRecord::Migration
  def change
    add_column :candidates, :is_profile_complete, :boolean, null: false, default: false

    Candidate.reset_column_information

    say_with_time 'updating is_profile_complete for Candidates' do
      Candidate.all.find_each do |candidate|
        candidate.touch
      end
    end
  end
end
