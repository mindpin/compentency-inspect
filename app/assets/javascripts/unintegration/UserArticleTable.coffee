@UserArticleTable = React.createClass
  render: ->
    <div className="user-article-table">
      <UserArticleTable.Table data={@props.data} />
    </div>

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            name:       '文章'
            created_at: '添加时间'
            actions:    '操作'
          data_set: @props.data.map (x)=>
            actions =
              <div>
                <a className="ui button mini blue basic" href={x.show_url}>
                  <i className='icon write' />
                  <span>查看</span>
                </a>
                <a className="ui button mini blue basic" href={x.share_url}>
                  <i className='icon write' />
                  <span>分享</span>
                </a>
              </div>

            {
              id: x.show_url
              name: x.name
              created_at: x.created_at
              actions: actions
            }

          th_classes: {
            name: 'collapsing'
            created_at: 'collapsing'
            actions: 'collapsing'
          }
          td_classes: {
            name: 'collapsing'
            created_at: 'collapsing'
            actions: 'collapsing'
          }
        }

        <ManagerTable data={table_data} title='个人文章中心' />
