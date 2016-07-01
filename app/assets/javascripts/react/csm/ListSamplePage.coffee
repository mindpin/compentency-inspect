@ListSamplePage = React.createClass
  getInitialState: ->
    items: @props.data.items
    next_animate_item: null

  render: ->
    <div className='list-sample-page'>
    {
      for item in @state.items
        animate = (@state.next_animate_item == item)

        <Item key={item.id} data={item} do_publish={@do_publish} animate={animate} />
    }
    </div>

  do_publish: (item)->
    items = @state.items
    next_animate_item = null

    for i in items
      if i.id == item.id
        item.published = true 
        next_animate_item = i

    @setState 
      items: items
      next_animate_item: next_animate_item
    # @animate item

  # animate: (item)->
  #   @setState next_animate_item: item

Item = React.createClass
  render: ->
    klass = new ClassName
      'item': true
      'published': @props.data.published
      'animate': @props.animate

    text = if @props.data.published then '已发布' else '未发布'

    <div className={klass}>
      {@props.data.id} - {text}
      {
        if not @props.data.published
          <a className='ui button mini green' onClick={@do_publish(@props.data)}>发布</a>
      }
    </div>

  do_publish: (item)->
    =>
      @published = item.published
      @props.do_publish(item)

  # componentDidMount: ->
  #   # console.log "mount #{@props.data.id}"

  # componentWillUpdate: (next_props)->
  #   console.log @props.data.id
  #   console.log @published
  #   console.log @props.data.published