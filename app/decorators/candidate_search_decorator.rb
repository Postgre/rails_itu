class CandidateSearchDecorator < Draper::Decorator
  include ActiveModel::SerializerSupport
  delegate_all
  delegate :total_pages, :total_count, :suggestions, to: :object
  delegate :current_page, :any?, :per_page, to: :object
  delegate :length, :first_page?, :last_page?, to: :object

  def facets_hash
    facets = {}
    object.facets.each do |facet|
      next if facet[1]["total"] <= 0
      facet_name         = facet[0]

      facet[1]["terms"].each do |facet_term|
        facet_key    = facet_term["term"]
        facet_value  = facet_term["count"]
        facets[facet_name] ||= {}
        facets[facet_name][facet_key] = facet_value
      end

      facets
    end
  end

  def meta
    meta = %w(total_pages total_count current_page any? per_page length first_page? last_page?)
    hsh = {facets: facets_hash}
    meta.each do |key|
      hsh[key.to_sym] = object.send(key)
    end
    hsh
  end
end
