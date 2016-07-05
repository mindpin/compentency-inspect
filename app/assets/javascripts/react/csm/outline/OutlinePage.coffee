@OutlinePage = React.createClass
  getInitialState: ->
    cid = location.href.split('#')[1]
    if cid? and cid.length
      cid = cid
    else
      cid = '0'

    cid: cid

  render: ->
    <div className='outline-page'>
      <OutlineSidebar ref='bar' outline_data={@props.outline_data} cid={@state.cid} page={@} />
      <OutlineContent ref='cnt' outline_data={@props.outline_data} cid={@state.cid} page={@} />
    </div>

  nav_to: (cid)->
    location.href = "/outline##{cid}"
    @setState cid: cid