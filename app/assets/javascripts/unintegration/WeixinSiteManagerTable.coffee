@WeixinSiteManagerTable = React.createClass
  render: ->
    <div className="weixin-site-manager-table">
      <div className="new-site">
        <a className="positive ui button" href={@props.data.new_url}>
          <i className='icon add' />
          新建
        </a>
      </div>
      <WeixinSiteManagerTable.Table data={@props.data.items} />
    </div>


  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            name: '名称'
            organization: '机构名称'
            url: '自定义路径'
            status: '状态'
            actions: '操作'
          data_set: @props.data.map (x)=>
            if x.status == "未发布"
              actions =
                <div>
                  <a className="ui button mini blue basic" href={x.edit_url}>
                    <i className='icon write' />
                    编辑
                  </a>
                </div>
            else
              null

            {
              id: x.name
              name: x.name
              status: x.status
              organization: x.organization
              url: x.url
              actions: actions
            }

          th_classes: {}
          td_classes: {
            actions: 'collapsing'
          }
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='微站管理' />
        </div>
