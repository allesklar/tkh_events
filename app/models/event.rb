class Event < ActiveRecord::Base

  tkh_searchable
  def self.tkh_search_indexable_fields
    indexable_fields = {
      name: 8,
      description: 3,
      body: 2
    }
  end

  def to_param
    name ? "#{id}-#{name.to_url}" : id
  end

end
