class AddPublishedAtToJobs < ActiveRecord::Migration
  def change
    add_column :jobs, :published_at, :datetime
    Job.reset_column_information

    say_with_time 'updating published_at' do
      Job.update_all('published_at = updated_at')
    end
  end
end
