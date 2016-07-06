@MultistagePieChart = React.createClass
  render: ->
    <div className="multistage-pie-chart">
    </div>

  make_pie_chart: (datas, inner_radius, outer_radius, deep)->
    pie = d3.layout.pie().sort(null).value (datas)->
      return datas.value
    piedata = pie(datas)
    arc = d3.svg.arc().innerRadius(inner_radius).outerRadius(outer_radius)

    arcs = @svg.selectAll("g#{deep}")
      .data(piedata)
      .enter()
      .append("g")
      .attr("transform", "translate(" + @width/2 + "," + @width/2 + ")")

    arcs.append("path")
      .attr "fill", (d, i)=>
        @unique_color_index.push(@unique_color_index[@unique_color_index.length - 1] + 1)
        return @colors_maker(@unique_color_index[@unique_color_index.length - 1])
      .attr "d", (d)->
        return arc(d)
      .on 'mouseover', (d)=>
        outer_dom = d3.event.target
        text_dom = jQuery(outer_dom).closest('g').find('text')[0]
        @tip.show(d, text_dom)
        jQuery(".d3-tip").css("pointer-events", "none")
      .on 'mouseout', (d)=>
        @tip.hide(d)
      .attr "style", (d)=>
        if !d.data.display
          return "display: none;"

    arcs.append("text")
      .attr "transform", (d)->
        x = arc.centroid(d)[0] * 1
        y = arc.centroid(d)[1] * 1
        return "translate(" + x + "," + y + ")"
      .attr("text-anchor", "middle")
      .attr("style", "pointer-events: none;")
      .text (d)->
        return d.data.name

  componentDidMount: ->
    @width = 1000
    @height = 1000
    dataset = @props.data.multistage_pie
    diameters = [0]
    @unique_color_index = [0]
    @colors_maker = d3.scale.category20c()

    @tip = d3.tip()
      .attr('class', 'd3-tip')
      .offset([-10, 0])
      .html (d)->
        "名称：" + d.data.name + "</br>数值：" + d.data.value

    @svg = d3.select(".multistage-pie-chart").append('svg')
      .attr('width', @width)
      .attr('height', @height)
    @svg.call(@tip)

    for item in dataset
      index = dataset.indexOf item
      #  每一层级半径+100
      diameters.push(diameters[diameters.length - 1] + 100)
      @make_pie_chart(item, diameters[index], diameters[index + 1], index)
    
    
