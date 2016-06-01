@LayoutAdminSidebar = React.createClass
  render: ->
    <div className="layout-admin-sidebar">
      <div className="sidebar-inner">
      {
        for item, idx in @props.data.items
          <div className="item" key={idx} >
            <a href={item.url} >
              <i className={"icon " + item.icon} >
              </i>
              <span>{item.name}</span>
            </a>
          </div>
      }
      </div>
    </div>
