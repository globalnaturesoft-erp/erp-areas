class AddNewColumnsToStatesAndDistricts < ActiveRecord::Migration[5.0]
  def change
    add_column :erp_areas_states, :note, :text
    add_column :erp_areas_districts, :code, :string, limit: 5
    add_column :erp_areas_districts, :note, :text
    add_column :erp_areas_districts, :state_code, :string

    # Add index for faster lookups
    add_index :erp_areas_districts, :state_code
  end
end
