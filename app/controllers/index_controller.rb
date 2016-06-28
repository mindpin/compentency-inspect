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

  def search_box
    @component_name = 'search_box'
    @component_data = {
      search_url: "/search_box_post_search",
      current_words: ["橘子", "苹果"],
      recommend_words: %w{苹果 香蕉 橘子 栗子 火龙果},
      results: [
        {title: "title1111", desc: "desc111"},
        {title: "title222", desc: "desc222"},
      ]
    }
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
end
