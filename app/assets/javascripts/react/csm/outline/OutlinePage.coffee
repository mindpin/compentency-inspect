@OutlinePage = React.createClass
  getInitialState: ->
    cid = location.href.split('#')[1]
    if cid? and cid.length
      cid = cid
    else
      cid = '0'

    cid: cid
    maximize: false

  render: ->
    klass = new ClassName
      'outline-page': true
      'maximize': @state.maximize

    <div className={klass}>
      <OutlineSidebar ref='bar' outline_data={@props.outline_data} cid={@state.cid} page={@} />
      <OutlineContent ref='cnt' 
        outline_data={@props.outline_data} 
        cid={@state.cid} 
        page={@} 
        maximize={@maximize}
      />
    </div>

  nav_to: (cid)->
    path = @props.path || 'outline'

    location.href = "/#{path}##{cid}"
    @setState cid: cid

  maximize: ->
    @setState maximize: true