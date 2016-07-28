class LearnerController < ApplicationController
  layout 'learner'

  def global
    @component_name = 'OutlineContent'
    @component_data = {}
  end
end