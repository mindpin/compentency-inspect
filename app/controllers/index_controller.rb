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

  def video_player
    @component_name = "video_player"
    @component_data = "http://pimfans.oss-cn-beijing.aliyuncs.com/%E9%93%B6%E8%A1%8C%E7%A7%91%E6%8A%80%E4%B8%AD%E5%BF%83%E5%9F%B9%E8%AE%AD%E5%B9%B3%E5%8F%B0/%E7%90%86%E8%B4%A2%E7%BB%8F%E7%90%86%E5%9F%B9%E8%AE%AD/%E7%90%86%E8%B4%A2%E7%BB%8F%E7%90%86%E5%9F%B9%E8%AE%AD-04-480p.mp4"
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

  # 打分
  def star_bar
    @component_name = 'star_bar'
    @component_data = {
      total_star_count: 10,
      post_url: "/star_bar_post_star_count"
    }
  end

  # 更新當前分數
  def star_bar_post_star_count
    render json: {
      curent_star_count: params[:star_count],
    }
  end
end
