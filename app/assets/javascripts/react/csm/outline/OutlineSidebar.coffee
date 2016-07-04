@OutlineSidebar = React.createClass
  render: ->
    cid = location.href.split('#')[1]
    if cid? and cid.length
      cid = cid
    else
      cid = '0'

    console.log cid

    <div className='outline-sidebar'>
    {
      for item in @props.outline_data
        klass0 = new ClassName
          "link": true
          "active": item.id == cid

        <div key={item.id} className='item'>
          <a href="javascript:;" className={klass0} onClick={@nav_to(item.id)}>
            <i className="icon #{item.icon}" /> {item.name}
          </a>
          {
            for sitem in item.children || []
              klass1 = new ClassName
                "slink": true
                "active": sitem.id == cid

              <a key={sitem.id} href="javascript:;" className={klass1} onClick={@nav_to(sitem.id)}>
                <i className="icon angle right" /> {sitem.name}
              </a>
          }
        </div>
    }
    </div>

  nav_to: (id)->
    =>
      location.href = "/outline##{id}"
      window.outline_content.setState {}
      @setState {}