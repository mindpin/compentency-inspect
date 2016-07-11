@OutlinePage = React.createClass
  getInitialState: ->
    cid = location.href.split('#')[1]
    if cid? and cid.length
      cid = cid
    else
      cid = '0'

    cid: cid
    maximize: false
    mobile_menu: false

  render: ->
    klass = new ClassName
      'outline-page': true
      'maximize': @state.maximize
      'mobile-menu': @state.mobile_menu

    <div className={klass}>
      <div className='mobile-topbar'>
        <a href='javascript:;' onClick={@show_mobile_menu}><i className='icon content' /></a>
        <div className='title'>KC 知识平台</div>
      </div>

      <OutlineSidebar ref='bar' outline_data={@props.outline_data} cid={@state.cid} page={@} />
      <OutlineContent ref='cnt' 
        outline_data={@props.outline_data} 
        cid={@state.cid} 
        page={@} 
        maximize={@maximize}
        restoresize={@restoresize}
      />
    </div>

  nav_to: (cid)->
    location.href = "/outline##{cid}"
    @setState 
      cid: cid
      mobile_menu: false

  maximize: ->
    @setState maximize: true

  restoresize: ->
    @setState maximize: false

  show_mobile_menu: ->
    @setState mobile_menu: true