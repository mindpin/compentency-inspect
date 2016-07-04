@OutlinePage = React.createClass
  render: ->
    cid = location.href.split('#')[1]
    if cid? and cid.length
      cid = cid
    else
      cid = '0'

    <div>
      <OutlineSidebar ref='bar' outline_data={@props.outline_data} cid={cid} page={@} />
      <OutlineContent ref='cnt' outline_data={@props.outline_data} cid={cid} page={@} />
    </div>

  nav_to: (cid)->
    location.href = "/outline##{cid}"
    @setState {}