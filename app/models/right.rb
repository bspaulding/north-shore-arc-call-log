# = Right
#
# === Purpose
# Encapsulates a controller/action pair that a user would be allowed to access.
#
#
# === Associations
# - has_and_belongs_to_many :roles[link:Role.html]
#
# === Usage
# A Right is created with a controller and action name. 
# It is then assigned to a Role or Roles that have the right.
# Upon a request to the system, the logged in user's roles are gathered, 
# and the requested controller/action pair are checked against all the 
# user's rights. If the requested controller and action are found in a right
# that the user has, they are allowed to continue. If not, then they are
# denied access to that part of the system.
#
# NOTE: You can grant access to an entire controller by leaving a Right's action blank.
# This is interpreted by the system as giving access to the entire controller.
#
class Right < ActiveRecord::Base
	# Associations
	has_and_belongs_to_many :roles
end
