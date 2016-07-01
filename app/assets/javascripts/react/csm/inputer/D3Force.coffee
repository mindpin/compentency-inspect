@D3Force = React.createClass
  render: ->
    <div className='d3-force' ref='dom'>
    </div>

  componentDidMount: ->
    @setState {}

  componentDidUpdate: ->
    width = 920
    height = 500
    graph = @props.graph

    force = d3.layout.force()
      .charge(-500)
      .linkDistance(150)
      .size([width, height])

    force
      .nodes(graph.nodes)
      .links(graph.links)
      .start()

    jQuery(ReactDOM.findDOMNode(@refs.dom)).find('svg').remove()

    dom = d3.select ReactDOM.findDOMNode(@refs.dom)

    svg = dom.append('svg')
      .attr('width', width)
      .attr('height', height)

    link = svg.selectAll('.link')
      .data graph.links
      .enter().append 'line'
      .attr 'class', 'link'

    node = svg.selectAll('.node')
      .data(graph.nodes)
      .enter().append('g')
      .attr 'class', 'node'

    circle = node.append 'circle'
        .attr 'r', 20
        .attr 'fill', (d)-> d.color
        .on 'click', (d)-> d.click()

    node.append 'text'
        .text (d)-> d.name
        .attr 'x', 22
        .attr 'y', 8

    force.on 'tick', ->
      link.attr 'x1', (d)-> d.source.x
          .attr 'y1', (d)-> d.source.y
          .attr 'x2', (d)-> d.target.x
          .attr 'y2', (d)-> d.target.y

      node.attr 'transform', (d)->
        "translate(#{d.x}, #{d.y})"


  # componentDidUpdate: ->
  #   width = 920
  #   height = 500
  #   graph = @props.graph

  #   force = d3.layout.force()
  #     .charge(-500)
  #     .linkDistance(200)
  #     .friction(0.8)
  #     .size([width, height])

  #   force
  #     .nodes(graph.nodes)
  #     .links(graph.links)
  #     .start()

  #   jQuery(ReactDOM.findDOMNode(@refs.dom)).find('svg').remove()

  #   dom = d3.select ReactDOM.findDOMNode(@refs.dom)

  #   svg = dom.append('svg')
  #     .attr('width', width)
  #     .attr('height', height)

  #   link = svg.selectAll('.link')
  #     .data graph.links
  #     .enter().append 'line'
  #     .attr 'class', 'link'

  #   node = dom.selectAll('.div-node')
  #     .data graph.nodes
  #     .enter()
  #     .append('div')
  #     .attr 'class', 'div-node'
  #     .style 'background-color', (d)-> d.color

  #   # circle = node.append 'circle'
  #   #     .attr 'r', 20
  #   #     .attr 'fill', (d)-> d.color
  #   #     .on 'click', (d)-> d.click()

  #   # node.append 'text'
  #   #     .text (d)-> d.name
  #   #     .attr 'x', 22
  #   #     .attr 'y', 8

  #   force.on 'tick', ->
  #     link.attr 'x1', (d)-> d.source.x
  #         .attr 'y1', (d)-> d.source.y
  #         .attr 'x2', (d)-> d.target.x
  #         .attr 'y2', (d)-> d.target.y

  #     node.style 'transform', (d)->
  #       "translate(#{d.x}px, #{d.y}px)"
