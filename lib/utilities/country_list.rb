class CountryList
  Data = YAML.load_file(File.join(Rails.root, 'config', 'countries.yml')) || {}

  class << self

    def all(&blk)
      blk ||= Proc.new { |country ,data| [data['name'], country] }
      Data.map &blk
    end

    alias :countries :all
  end
end
