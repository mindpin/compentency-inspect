@ViewsTab = React.createClass
  render: ->
    name = @props.data.name

    klasses = ['read', 'outline', 'graph', 'target', 'case'].map (_name)=>
      new ClassName
        'item': true
        'active': name == _name

    <div className='sample-views-tab'>
      <div className='ui tabular menu' style={display: 'none'}>
        <a className={klasses[0]} onClick={@tab('read')}>阅读视图</a>
        <a className={klasses[1]} onClick={@tab('outline')}>大纲视图</a>
        <a className={klasses[2]} onClick={@tab('graph')}>图形视图</a>
        <a className={klasses[3]} onClick={@tab('target')}>目标视图</a>
        <a className={klasses[4]} onClick={@tab('case')}>案例视图</a>
      </div>

      <div className='tab-content'>
      {
        switch name
          when 'read'
            <ReadView data={@props.data.view_data} />
          when 'outline'
            <OutlineView data={@props.data.view_data} />
          when 'graph'
            <GraphView />
          when 'target'
            <TargetView data={@props.data.view_data}/>
          when 'case'
            <CaseView data={@props.data.view_data}/>
      }
      </div>
    </div>

  tab: (name)->
    =>
      Turbolinks.visit "/views/#{name}"
