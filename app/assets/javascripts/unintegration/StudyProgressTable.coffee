@StudyProgressTable = React.createClass
  render: ->
    thead_data =
      title:           @props.data.bottom_name
      category_values: @category_values()

    tbody_data =
      knowledge_point_values: @knowledge_point_values()
      category_values:        @category_values()
      get_num:                @get_num
      get_total_num:          @get_total_num

    <div className="study-progress-table">
      <table className="ui celled table">
        <StudyProgressTable.THead data={thead_data}/>
        <StudyProgressTable.TBody data={tbody_data}/>
      </table>
    </div>

  category_values: ->
    category_values = []
    for item in @props.data.items[0].nums
      category_values.push item.category_value
    category_values

  get_num: (knowledge_point_value, category_value)->
    for item in @props.data.items
      if item.name == knowledge_point_value
        for num_item in item.nums
          if num_item.category_value == category_value
            return num_item.num

  get_total_num: (category_value)->
    total_num = 0
    knowledge_point_count = @knowledge_point_values().length

    for item in @props.data.items
      for num_item in item.nums
        if num_item.category_value == category_value
          total_num += num_item.num/knowledge_point_count

    total_num

  knowledge_point_values: ->
    knowledge_point_values = []
    for item in @props.data.items
      knowledge_point_values.push item.name
    knowledge_point_values

  statics:
    THead: React.createClass
      render: ->
        <thead>
          <tr>
            <th key={@props.data.title}>{@props.data.title}</th>
            {
              for item in @props.data.category_values
                <th key={item}>{item}</th>
            }
          </tr>
        </thead>

    TBody: React.createClass
      render: ->
        <tbody>
          {
            for knowledge_point_value, i in @props.data.knowledge_point_values
              <tr key={i}>
                <td key={knowledge_point_value}>{knowledge_point_value}</td>
                {
                  for category_value, j in @props.data.category_values
                    num = @props.data.get_num(knowledge_point_value, category_value)
                    @build_td_by_num(num,"#{i}_#{j}")
                }
              </tr>
          }
          <tr key="整体进度">
            <td>整体进度</td>
            {
              for category_value, i in @props.data.category_values
                num = @props.data.get_total_num(category_value)
                num = Math.round(num)
                @build_td_by_num(num, i)
            }
          </tr>
        </tbody>

      build_td_by_num: (num, key)->
        switch num
          when 0
            <td key={key}>--</td>
          when 100
            <td className="completed" key={key}>
              <div className="num">{num}%</div>
              <div className="progress" style={width: "#{num}%"}>
              </div>
            </td>
          else
            <td className="studing" key={key}>
              <div className="num">{num}%</div>
              <div className="progress" style={width: "#{num}%"}>
              </div>
            </td>
