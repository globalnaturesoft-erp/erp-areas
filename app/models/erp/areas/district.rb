module Erp::Areas
  class District < ApplicationRecord
    belongs_to :state

    # data for dataselect ajax
    def self.dataselect(keyword='', params={})
      query = self.all.order('code')

      # filter by keyword
      if keyword.present?
        keyword = keyword.strip.downcase
        query = query.where('LOWER(name) LIKE ? OR LOWER(code) LIKE ?', "%#{keyword}%", "%#{keyword}%")
      end

      # filter by parent
      if params[:parent_value].present?
				query = query.where(params[:parent_id] => params[:parent_value])
			end

      query = query.limit(100).map{|district| {value: district.id, text: district.name} }
    end
  end
end
