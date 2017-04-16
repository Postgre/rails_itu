FactoryGirl.define do
  factory :job_application do
    job
    candidate
    cover_letter { Faker::Lorem.sentence(3) }
    resume {
      ActionDispatch::Http::UploadedFile.new(
        :tempfile => File.new(Rails.root.join('spec','support','files','pdf-sample.pdf')),
        :filename => File.basename(File.new(Rails.root.join('spec','support','files','pdf-sample.pdf')))
      )
    }
  end
end
