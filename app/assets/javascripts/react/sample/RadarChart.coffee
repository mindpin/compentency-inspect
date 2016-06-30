@RadarChart = React.createClass
  render: ->
    <div className="radar-chart">
      <svg width= 1000 height=2000></svg>
    </div>

  getColor:(idx)->
    palette = [
      '#2ec7c9', '#b6a2de', '#5ab1ef', '#ffb980', '#d87a80',
      '#8d98b3', '#e5cf0d', '#97b552', '#95706d', '#dc69aa',
      '#07a2a4', '#9a7fd1', '#588dd5', '#f5994e', '#c05050',
      '#59678c', '#c9ab00', '#7eb00a', '#6f5553', '#c14089'
    ]
    return palette[idx % palette.length];

  componentDidMount: ->
    width = 600 
    height = 300
    
    main = d3.select('.radar-chart svg').append('g')
    .classed('main', true)
    .attr('transform', "translate(" + width/2 + ',' + height/2 + ')')


    data = {fieldNames:[],values_percent:[[]]}

    for item in @props.data.radar.items
      data.fieldNames.push(item.name)
      data.values_percent[0].push(100*item.count/@props.data.radar.max_count)
    total = @props.data.radar.items.length

    radius = 100
    # 网轴分4级
    level = 4
    # 网轴范围
    rangeMin = 0
    rangeMax = 100
    arc = 2 * Math.PI
    # 每项指标所在角度
    onePiece = arc/total


    # 计算坐标
    polygons = {
      webs: [],
      webPoints: []
    }

    for k in [level...0]
      webs = ''
      webPoints = []
      r = radius/level * k

      for i in [0...total]
        x = r * Math.sin(i * onePiece)
        y = r * Math.cos(i * onePiece)
        webs += x + ',' + y + ' '
        webPoints.push({x: x,y: y})
      polygons.webs.push(webs)
      polygons.webPoints.push(webPoints)


    # 绘制网轴
    webs = main.append('g').classed('webs', true)
    webs.selectAll('polygon')
      .data(polygons.webs)
      .enter()
      .append('polygon')
      .attr 'points', (d)->
        return d;
                  
    # 添加纵轴
    lines = main.append('g').classed('lines', true);
    lines.selectAll('line')
      .data(polygons.webPoints[0])
      .enter()
      .append('line')
      .attr('x1', 0)
      .attr('y1', 0)
      .attr 'x2', (d)-> 
        return d.x;
      .attr 'y2', (d)->
        return d.y;

    # # # 计算雷达图表坐标
    areasData = []
    values = data.values_percent

    for i in [0...values.length]
      value = values[i]
      area = ''
      points = []
      for k in [0...total]
        r = radius * (value[k] - rangeMin)/(rangeMax - rangeMin);
        x = r * Math.sin(k * onePiece)
        y = r * Math.cos(k * onePiece)
        area += x + ',' + y + ' '
        points.push({x: x,y: y})
      areasData.push({polygon:area,points:points})

    # 添加g分组包含所有雷达图区域
    areas = main.append('g').classed('areas', true)
    # 添加g分组用来包含一个雷达图区域下的多边形以及圆点
    areas.selectAll('g')
      .data(areasData)
      .enter()
      .append('g')
      .attr 'class',(d, i)->
        return 'area' + (i+1)
    for i in [0...areasData.length]
      # 依次循环雷达的每个图区域
      area = areas.select('.area' + (i+1))
      areaData = areasData[i]
      # 绘制区域内的多边形
      area.append('polygon')
        .attr('points', areaData.polygon)
        .attr 'stroke', (d, index)=>
            return @getColor(i);
        .attr 'fill', (d, index)=>
            return @getColor(i);
      # 绘制点
      circles = area.append('g').classed('circles', true);
      circles.selectAll('circle')
        .data(areaData.points)
        .enter()
        .append('circle')
        .attr 'cx', (d)->
            return d.x;
        .attr 'cy', (d)->
            return d.y;
        .attr('r', 3)
        .attr 'stroke',(d, index)=>
            return @getColor(i);
      # 计算文字标签坐标
      textPoints = [];
      textRadius = radius + 20;

      for i in [0...total]
        x = textRadius * Math.sin(i * onePiece)
        y = textRadius * Math.cos(i * onePiece)
        textPoints.push({x:x,y:y})

      # 绘制文字标签
      texts = main.append('g').classed('texts', true);
      texts.selectAll('text')
        .data(textPoints)
        .enter()
        .append('text')
        .attr 'x', (d)->
          return d.x;
        .attr 'y', (d)->
          return d.y;
        .text (d,i)->
          return data.fieldNames[i];





             








 

















