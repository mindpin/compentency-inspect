@AdminUsersPage = React.createClass
  render: ->
    <div className='admin-users-page'>
      <div>
      <a className='ui button green' href={@props.data.new_user_url}>创建账号</a>
      </div>
      <UsersTable data={@props.data} />
    </div>

UsersTable = React.createClass
  render: ->
    table_data = {
      fields:
        name: '用户名'
        login: '登录名'
        role_str: '角色'
        actions: '操作'
      data_set: @props.data.users.map (x)->
        jQuery.extend x, {
          actions:
            <a className='ui button mini green' href={x.admin_edit_url}>
              <i className='ui edit' /> 修改
            </a>
        }
      data_set: @props.data.users

      th_classes: {
      }
      td_classes: {
      }

      paginate: @props.data.paginate
    }

    <div className='ui segment'>
      <ManagerTable data={table_data} title='账号管理' />
    </div>