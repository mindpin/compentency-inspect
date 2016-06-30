@PieChart = React.createClass
  render: ->
    <div className="pie-chart">
    </div>

  componentDidMount: ->
    width = 400
    height = 400
    dataset = @props.data.pie
   
    tip = d3.tip()
      .attr('class', 'd3-tip')
      .offset([-10, 0])
      .html (d)->
        return "名称：" + d.data.name + "数值" + d.data.count

    svg = d3.select(".pie-chart").append('svg')
      .attr('width', width)
      .attr('height', height)
    svg.call(tip)

    pie = d3.layout.pie().value (d)->
      return d.count
    piedata = pie(dataset)

    outerRadius = 150
    innerRadius = 0
    arc = d3.svg.arc().innerRadius(innerRadius).outerRadius(outerRadius)
    color = d3.scale.category10()

    arcs = svg.selectAll("g")
      .data(piedata)
      .enter()
      .append("g")
      .attr("transform", "translate(" + width/2 + "," + width/2 + ")")

    arcs.append("path")
      .attr "fill", (d, i)->
        return color(i)
      .attr "d", (d)->
        return arc(d)
      .on 'mouseover', (d)->
        outer_dom = d3.event.target
        text_dom = jQuery(outer_dom).closest('g').find('text')[0]
        tip.show(d, text_dom)
        jQuery(".d3-tip").css("pointer-events", "none")
      .on 'mouseout', (d)->
        tip.hide(d)
 
    arcs.append("text")
      .attr "transform", (d)->
        x = arc.centroid(d)[0] * 1.4
        y = arc.centroid(d)[1] * 1.4
        return "translate(" + x + "," + y + ")"
      .attr("text-anchor", "middle")
      .attr("style", "pointer-events: none;")
      .attr 'id', (d)->
        return d.data.name
      .text (d)->
        return d.data.name









      











