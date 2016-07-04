class OutlineController < ApplicationController
  layout 'outline'

  def global
    @component_name = 'OutlineContent'
    @component_data = {}
  end
end