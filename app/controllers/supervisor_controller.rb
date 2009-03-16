class SupervisorController < ApplicationController
  before_filter :authenticate, :authorize
  
  def index
  end
end