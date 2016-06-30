class IndexController < ApplicationController
  layout 'csm'

  def index
    @component_name = 'sample_index_page'
    @component_data = {}
  end

  def getmd
    file = params[:file]
    text = File.read File.join(Rails.root, 'csm', 'yaml', 'markdowns', file)
    render text: text
  end

  def getimgs
    file = params[:file]
    text = File.read File.join(Rails.root, 'csm', 'yaml', 'images', file)
    render json: text.lines
  end

  def search_box_post_search
    render json: {
      recommend_words: %w{盖饭 拉条子 凉皮},
      results: [
        {title: "title333", desc: "desc333"},
        {title: "title4444", desc: "desc4444"},
      ]
    }
  end

  def views
    name = params[:name]
    view_data = case name
    when 'read'
      YAML.load_file File.join(Rails.root, 'csm', 'yaml', '理财经理培训.yaml')
    when 'case'
      YAML.load_file File.join(Rails.root, 'csm', 'ques', '理财产品销售.yaml')
    end

    @component_name = 'views_tab'
    @component_data = {
      name: name,
      view_data: view_data
    }
  end
end
