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
    if params[:keywords] == nil
      return render json: {
        recommend_words: SearchBox::Parser.get_hot_sorted_keywords()[0..2],
        results: []
      }
    end
    render json: {
      recommend_words: SearchBox::Parser.get_releated_keywords_by_keyword(params[:keywords])[0..5],
      results: SearchBox::Parser.get_qustions_by_keywords(params[:keywords])
    }
  end

  def views
    name = params[:name]
    view_data = case name
    when 'read'
      YAML.load_file File.join(Rails.root, 'csm', 'yaml', '理财经理培训.yaml')
    when 'case'
      YAML.load_file File.join(Rails.root, 'csm', 'ques', '理财产品销售.yaml')
    when 'target'
      {
        search_url: "/search_box_post_search",
        dashboard_url: "/user/dashboard",
        current_words: [],
        recommend_words: SearchBox::Parser.get_hot_sorted_keywords()[0..2],
        results: []
      }
    end

    @component_name = 'views_tab'
    @component_data = {
      name: name,
      view_data: view_data
    }
  end

end
