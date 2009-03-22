# = SupervisorController
#
# Author: Bradley J. Spaulding
#
# === Purpose
# Provides a space for the Supervisor home screen.
class SupervisorController < ApplicationController
  before_filter :authenticate, :authorize
  
  # Displays Supervisor home screen.
  def index
  end
end