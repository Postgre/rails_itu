class SetCandidateRole < ActiveRecord::Migration
  def change
    say_with_time 'setting candidate role' do
      Candidate.find_each do |candidate|
        candidate.user.grant :candidate
      end
    end
  end
end
