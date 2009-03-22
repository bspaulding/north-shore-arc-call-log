# = Role
#
# === Purpose
# Encapsulates a groups of rights available to a level of user access.
#
#
# === Associations
# - has_and_belongs_to_many :people[link:Person.html]
# - has_and_belongs_to_many :rights[link:Right.html]
#
# === Usage
# A Role is given a name. It is then associated with any number of rights[link:Right.html] and people[link:Person.html].
# 	admin_all_right = Right.create!(:name => "Administrator (all)", :controller => "administrator")
# 	admin = Role.create!(:name => "Administrator")
# 	admin.rights << admin_all_right
# 	user_james_keel.roles << admin
# Now, user_james_keel is an Administrator, and can access all actions in the AdministratorController, 
# via the Administrator Role.
#
class Role < ActiveRecord::Base
	has_and_belongs_to_many :people
	has_and_belongs_to_many :rights
end
