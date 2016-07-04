@OutlineSidebar = React.createClass
  render: ->
    <div className='outline-sidebar'>
    {
      for item in @props.outline_data
        klass0 = new ClassName
          "link": true
          "active": item.id == @props.cid

        <div key={item.id} className='item'>
          <a href="javascript:;" className={klass0} onClick={@nav_to(item.id)}>
            <i className="icon #{item.icon}" /> {item.name}
          </a>
          {
            for sitem in item.children || []
              klass1 = new ClassName
                "slink": true
                "active": sitem.id == @props.cid

              <a key={sitem.id} href="javascript:;" className={klass1} onClick={@nav_to(sitem.id)}>
                <i className="icon angle right" /> {sitem.name}
              </a>
          }
        </div>
    }
    </div>

  nav_to: (cid)->
    =>
      @props.page.nav_to(cid)