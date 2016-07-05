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

  # 学习进度统计
  def study_progress
    @component_name = 'study_progress_table'
    @component_data = DemoData.study_progress_data
  end
end
