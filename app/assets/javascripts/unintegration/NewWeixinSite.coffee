@NewWeixinSite = React.createClass
  render: ->
    <div className="new-weixin-site">
      <form className="ui form">
        <div className="field">
          <label>名称</label>
          <input type="text" placeholder="名称" />
        </div>
        <div className="field">
          <label>自定义路径</label>
          <input type="text" placeholder="自定义路径" />
        </div>
        <div className="field">
          <label>机构</label>
          <NewWeixinSite.OrganizationTree data={@props.data}/>
        </div>
        <div className="field">
          <label>自定义规则</label>
          <textarea />
        </div>
        <button className="ui button" type="submit">新建</button>
      </form>
    </div>

  statics:
    OrganizationTree: React.createClass
      getInitialState: ->
        checked_organization_ids: []

      render: ->
        organization_data =
          organization:                    @props.data.organization
          organization_check_state:        @organization_check_state
          taggle_organization_check_state: @taggle_organization_check_state

        <div className="organization-tree">
          <NewWeixinSite.Organization data={organization_data} />
        </div>

      get_ancestor_ids: (organization)->
        ancestor_ids = []
        current_org_id = organization.id
        parent_id = 0
        while parent_id != undefined
          parent_id = @parent_info_hash[current_org_id]
          if parent_id != undefined
            ancestor_ids.push parent_id
            current_org_id = parent_id
        ancestor_ids

      organization_check_state: (organization)->
        if @state.checked_organization_ids.indexOf(organization.id) != -1
          return "checked"

        children_checked_count = 0
        children = organization.children || []
        for child in children
          state = @organization_check_state(child)
          children_checked_count +=1 if state == "checked"

        return "unchecked" if children_checked_count == 0
        return "checked" if children_checked_count == children.length
        return "partchecked"

      get_self_and_descendant_ids: (organization)->
        self_and_descendant_ids = [organization.id]

        _digui_get_children = (org)->
          children = org.children || []
          for child in children
            self_and_descendant_ids.push child.id
            _digui_get_children(child)

        _digui_get_children(organization)
        self_and_descendant_ids

      taggle_organization_check_state: (organization)->
        checked_organization_ids = @state.checked_organization_ids
        if checked_organization_ids.indexOf(organization.id) == -1
          @checked_organization(organization)
        else
          @unchecked_organization(organization)

      checked_organization: (organization)->
        checked_organization_ids = @state.checked_organization_ids

        for id in @get_self_and_descendant_ids(organization)
          if checked_organization_ids.indexOf(id) == -1
            checked_organization_ids.push id

        @setState
          checked_organization_ids: checked_organization_ids

      unchecked_organization: (organization)->
        checked_organization_ids = @state.checked_organization_ids

        for id in @get_self_and_descendant_ids(organization)
          index = checked_organization_ids.indexOf(id)
          if index != -1
            checked_organization_ids.splice(index, 1)

        @setState
          checked_organization_ids: checked_organization_ids

    Organization: React.createClass
      render: ->
        <div className="organization open">
          <div className="line">
            {@get_icon_dom()}
            {@get_checkbox_dom()}
            <div className="name">{@props.data.organization.name}</div>
          </div>
          {
            if @has_children()
              <div className="children" >
              {
                for item in @props.data.organization.children
                  organization_data =
                    organization:                    item
                    organization_check_state:        @props.data.organization_check_state
                    taggle_organization_check_state: @props.data.taggle_organization_check_state
                  <NewWeixinSite.Organization data={organization_data} />
              }
              </div>
          }
        </div>

      get_checkbox_dom: ()->
        <div
          className="checkbox #{@props.data.organization_check_state(@props.data.organization)}"
          onClick={@taggle_check_state()}
          >
          <div className="inner">
          </div>
        </div>

      taggle_check_state: ->
        =>
          @props.data.taggle_organization_check_state(@props.data.organization)

      get_icon_dom: ()->
        if @has_children()
          <div className="taggle-icon" onClick={@taggle_classname}>
            <i className="angle right icon"></i>
            <i className="angle down icon"></i>
          </div>
        else
          <div className="taggle-icon place-holder">
          </div>

      taggle_classname: ->
        $div = jQuery(ReactDOM.findDOMNode(@))
        $div.toggleClass("close")
        $div.toggleClass("open")

      has_children: ->
        @props.data.organization.children?.length? > 0
