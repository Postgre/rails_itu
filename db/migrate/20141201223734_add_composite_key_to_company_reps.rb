class AddCompositeKeyToCompanyReps < ActiveRecord::Migration
  def change
    say_with_time("Removing duplicates and adding a composite index using user_id and company_id") do
      remove_duplicates
      add_index :company_reps, [:user_id, :company_id], unique: true
    end
  end

  private
    def remove_duplicates
      grouped = CompanyRep.all.group_by{|cr| [cr.company_id, cr.user_id]}
      grouped.values.each do |duplicates|
        first_one = duplicates.shift
        duplicates.each{|double| double.destroy}
      end
    end
end
