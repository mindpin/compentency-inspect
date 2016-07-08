class ToolsController < ApplicationController
  layout 'csm'

  def ques
    data = YAML.load_file File.join(Rails.root, 'csm', 'ques', '理财产品销售.yaml')
    object = data[0]

    @component_name = 'fact_tag_quick_recorder'
    @component_data = {
      object: object
    }
  end
end