class UnintegrationController < ApplicationController
  layout 'unintegration'

  # 视频播放
  def video_player
    @component_name = "video_player"
    @component_data = "http://pimfans.oss-cn-beijing.aliyuncs.com/%E9%93%B6%E8%A1%8C%E7%A7%91%E6%8A%80%E4%B8%AD%E5%BF%83%E5%9F%B9%E8%AE%AD%E5%B9%B3%E5%8F%B0/%E7%90%86%E8%B4%A2%E7%BB%8F%E7%90%86%E5%9F%B9%E8%AE%AD/%E7%90%86%E8%B4%A2%E7%BB%8F%E7%90%86%E5%9F%B9%E8%AE%AD-04-480p.mp4"
  end

  # 聊天框相关
  def chat_box
    @component_name = "chat_box"
    @component_data = {
      post_url: "/unintegration/return_message",
      chater_self: {id: 1, name: "我"},
      messages: [
        {chater: {id: 1, name: "我"}, text: "吃饭"},
        {chater: {id: 2, name: "chat机器人"}, text: "我不用吃饭"},
        {chater: {id: 1, name: "我"}, text: "睡觉"},
        {chater: {id: 2, name: "chat机器人"}, text: "我不用睡觉"}
      ]
    }
  end

  # 聊天框相关
  def return_message
    render json: {chater:{id: 2,name: "chat机器人"},text: "我不用" + params[:text]}
  end

  # 饼图
  def pie_chart
    @component_name = 'pie_chart'
    @component_data = {
      pie: [
        { name: 'Ruby',   count:100 },
        { name: 'python', count:70 },
        { name: 'perl',   count:20 },
        { name: 'php',    count:90 }
      ]
    }
  end

  # 雷达图
  def radar_chart
    @component_name = 'radar_chart'
    @component_data = {
      radar: {
        max_count: 150,
        items: [
          { name: 'Ruby',   count: 100 },
          { name: 'python', count: 70 },
          { name: 'perl',   count: 40 },
          { name: 'js',     count: 120 },
          { name: 'c++',    count: 80 },
          { name: 'java',   count: 80 },
          { name: 'php',    count: 90 }
        ]
      }
    }
  end

  # 折线图
  def trend_chart
    @component_name = 'trend_chart'
    @component_data = {
      trend: [
        { date: 5,  count: 35 },
        { date: 10, count: 25 },
        { date: 15, count: 25 },
        { date: 20, count: 45 },
        { date: 25, count: 45 },
        { date: 30, count: 5 }
      ]
    }
  end

  def multistage_pie_chart
    @component_name = 'multistage_pie_chart'
    @component_data = {
      multistage_pie: tree_nodes_to_arrays()
    }


    tree_nodes_to_arrays()
  end

  # 打分
  def star_bar
    @component_name = 'star_bar'
    @component_data = {
      total_star_count: 10,
      post_url: "/unintegration/star_bar_post_star_count"
    }
  end

  # 打分相关
  def star_bar_post_star_count
    render json: {
      current_star_count: params[:star_count],
    }
  end

# ----------------------------------------------------
  def tree_nodes_to_arrays
    tree_datas_hash = 
    {
      name: "客户",
      value: 100,
      children: [
        {
          name: "家庭状况",
          value: 40,
          children: [
            {
              name: "子女状况",
              value: 50,
              children: [
                {name: "无子女",   value: 30},
                {name: "独生子女", value: 30},
                {name: "多子女",   value: 40}
              ]
            },
            {
              name: "婚姻状况",
              value: 50,
              children: [
                {name: "未婚",   value: 30},
                {name: "已婚",   value: 30},
                {name: "离婚",   value: 30},
                {name: "丧偶",   value: 10}
              ]
            }
          ]
        },
        {
          name: "个人状况",
          value: 40,
          children: [
            {
              name: "健康状况",
              value: 50,
              children: [
                {name: "良好",     value: 30},
                {name: "亚健康",   value: 30},
                {name: "轻疾病",   value: 30},
                {name: "重疾病",   value: 10}
              ]
            },
            {
              name: "年龄",
              value: 50,
              children: [
                {name: "青年",   value: 30},
                {name: "中年",   value: 30},
                {name: "老年",   value: 40}
              ]
            }
          ]
        },
        {
          name: "工作状况",
          value: 20,
          children: [
            {name: "刚入职",   value: 20},
            {name: "稳定",     value: 30},
            {name: "退休",     value: 20},
            {name: "失业",     value: 20},
            {name: "创业",     value: 10}
          ]
        },
        {
          name: "财务状况",
          value: 20,
          children: [
            {name: "普通",    value: 30},
            {name: "负债",    value: 10},
            {name: "大量现金", value: 60}
          ]
        }
      ]
    }

    tree_datas_hash_ary = [tree_datas_hash]
    results_arys = []

    results_arys = make_a_layer_ary(tree_datas_hash_ary, results_arys)
    return results_arys

    # p results_arys.length
    # results_arys.each do |x|
    #   p '=====================>'
    #   p x
    # end
  end

  def make_a_layer_ary(input_ary, results_arys)
    if results_arys.length == 0
      total_count = 0
      scan_to_add_blank_to_first_layer = input_ary.map do |node|
        total_count += node[:value]
        node[:display] = true
        node
      end
      if total_count < 100
        scan_to_add_blank_to_first_layer.push({:name => '', :value => 100 - total_count, display: false })
      end
      make_a_layer_ary(scan_to_add_blank_to_first_layer, results_arys.push(scan_to_add_blank_to_first_layer))  
    else
      make_next_layer = input_ary.map do |node|
        if node[:children].present?
          total_count = 0
          node_childs = []
          node[:children].each do |child|
            child[:value] = 100 * (node[:value].to_f/100) * (child[:value].to_f/100)
            child[:display] = true
            total_count += child[:value]
            node_childs.push(child)
          end
          if total_count < node[:value]
             node_childs.push({
                name: "",
                value: node[:value] - total_count,
                display: false
              })
          end
          node = node_childs
          node
        else
          node[:display] = false
          node
        end
      end
      if make_next_layer.flatten.length > make_next_layer.length
          make_a_layer_ary(make_next_layer.flatten,results_arys.push(make_next_layer.flatten))
      else
        return results_arys
      end
    end
  end
end
