class EmsUserAvatarUrlValidator
  def self.valid? url
    return valid_amazon_avatar_url?(url) if Rails.env.production?
    return valid_asset_path_url?(url)
  end

  private

    def self.valid_amazon_avatar_url? url
      uri = URI(url)
      request = Net::HTTP.new(uri.host)
      response= request.request_head(uri.path)
      is_valid = (response.code.to_i == 200)
    end

    def self.valid_asset_path_url? url
      # TODO: create asset path url validation (could be some REGEX match)
      true
    end
end
