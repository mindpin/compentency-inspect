@TrendChart = React.createClass
  render: ->
    <div className="trend-chart">
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
    dataset = []
    for point in @props.data.trend
      station = {}
      station.x = point.date
      station.y = point.count
      dataset.push(station)

    padding = { top: 50, right: 50, bottom: 50, left: 50 }
    width = 600
    height = 300
    main = d3.select('.trend-chart svg')
    .append('g')
    .classed('main', true)
    .attr('transform', "translate(" + padding.top + ',' + padding.left + ')');

    xScale = d3.scale
    .linear()
    .domain d3.extent dataset,(d)-> 
      return d.x
    .range [0,width - padding.left - padding.right]

    yScale = d3.scale.linear().domain [0,d3.max(dataset,(d)->
                                      return d.y
    )]
    .range [height - padding.top - padding.bottom, 0]

    xAxis = d3.svg.axis().scale(xScale).orient('bottom');
    yAxis = d3.svg.axis().scale(yScale).orient('left');

    # 绑定坐标轴
    main.append('g')
    .attr('class', 'axis')
    .attr('transform', 'translate(0,' + (height - padding.top - padding.bottom) + ')')
    .call(xAxis);

    main.append('g')
    .attr('class', 'axis')
    .call(yAxis);

    # 线
    line = d3.svg.line()
    .x (d)->
      return xScale(d.x)
    .y (d)->
      return yScale(d.y)
    .interpolate('linear')

    main.append('path').attr('class', 'line').attr('d', line(dataset));

    # 点
    main.selectAll('circle')
    .data(dataset)
    .enter()
    .append('circle')
    .attr 'cx', (d)->
      return xScale(d.x);
    .attr 'cy', (d)->
      return yScale(d.y)
    .attr('r', 4)
    .attr 'fill' , (d,i)=>
      return @getColor(i)

    # text
    main.selectAll(".MyText")
    .data(dataset)
    .enter()
    .append("text")
    .attr("class","MyText")
    .attr "dx",(d)->
      return xScale(d.x)
    .attr "dy",(d)->
      return yScale(d.y)-padding.top/5
    .text (d)->
      return d.y















          

