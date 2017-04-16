class SetPositions < ActiveRecord::Migration
  def change
    say_with_time 'setting positions' do
      %w(Candidate Job).each do |skillable_class|
        skillable_class.classify.constantize.find_each do |skillable|
          skillable.skill_category_records.each_with_index do |category_record, index|
            category_record.update_column :position, index+1
            category_record.skill_records.each_with_index do |skill_record, index|
              skill_record.update_column :position, index+1
            end
          end
        end
      end
    end
  end
end
