class ParserController < ApplicationController
  layout 'csm'

  def ques_yaml
    component 'QUESYamlParser', {}
  end
end