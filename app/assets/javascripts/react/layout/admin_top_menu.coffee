@LayoutAdminTopMenu = React.createClass
  render: ->
    user = @props.data.current_user
    console.log user
    <div className="layout-admin-top-menu admin ui menu top fixed">
      <div className="right menu">
        <a key='name' className='item' href='javascript:;'>{user.name}</a>
        <a key='sign-out' className='item' onClick={@do_sign_out}>登出</a>
      </div>
    </div>

  do_sign_out: ->
    jQuery.ajax
      url: @props.data.current_user.admin_sign_out
      type: 'delete'
    .done =>
      location.href = @props.data.current_user.admin_sign_in
