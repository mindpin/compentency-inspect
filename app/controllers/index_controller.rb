class IndexController < ApplicationController
  layout 'csm'

  def index
    redirect_to "/sample"
  end

  def sample
    data = YAML.load_file File.join(Rails.root, 'csm', 'yaml', '理财经理培训.yaml')

    @component_name = 'csm_sample_page'
    @component_data = {
      data: data
    }
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

  def pie_graph
    @component_name = 'pie_graph'
    @component_data = [
      {name: 'Ruby',count:100},
      {name: 'python',count:70},
      {name: 'perl',count:20},
      {name: 'php',count:90}
    ]

  end
end
