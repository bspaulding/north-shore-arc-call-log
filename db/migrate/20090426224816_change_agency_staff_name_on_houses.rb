class ChangeAgencyStaffNameOnHouses < ActiveRecord::Migration
  def self.up
  	rename_column :houses, :agency_staff, :outside_agency_staff
  end

  def self.down
	  rename_column :houses, :outside_agency_staff, :agency_staff
  end
end
