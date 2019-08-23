class ErrorsController < ApplicationController
  layout 'errors'
  def show
    render params[:code], status: params[:code]
  end
end