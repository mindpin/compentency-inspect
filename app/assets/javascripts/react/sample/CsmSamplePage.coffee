@CsmSamplePage = React.createClass
  getInitialState: ->
    data: @props.data.data
    tab: 1

  render: ->
    klasses = [1, 2, 3, 4, 5].map (idx)=>
      new ClassName
        'item': true
        'active': @state.tab == idx

    <div className='csm sample page'>
      <div className='ui message warning'>
        Knowledge Camp 知识库产品概念静态演示
      </div>

      <div className='ui tabular menu'>
        <a className={klasses[0]} onClick={@tab(1)}>阅读视图</a>
        <a className={klasses[1]} onClick={@tab(2)}>大纲视图</a>
        <a className={klasses[2]} onClick={@tab(3)}>图形视图</a>
        <a className={klasses[3]} onClick={@tab(4)}>目标视图</a>
        <a className={klasses[4]} onClick={@tab(5)}>案例视图</a>
      </div>

      {
        switch @state.tab
          when 1
            <CSMReader root={@state.data[0]} />
          when 2
            <PathNodesNav nodes={@state.data} />
          when 3
            <div>
            <img src='http://i.teamkn.com/i/mAzYspqn.png' style={width: '100%'}/>
            </div>
          when 4
            <div />
          when 5
            <div />
      }

    </div>

  tab: (idx)->
    =>
      @setState tab: idx

Placeholder = React.createClass
  render: ->
    <div className='csm-placeholder'>
      <i className='icon file text outline' /> {@props.desc}
    </div>

PathNodesNav = React.createClass
  render: ->
    <div className='csm-path-nodes-nav'>
    {
      for node, idx in @props.nodes
        <Node key={idx} node={node} />
    }
    </div>

Node = React.createClass
  getInitialState: ->
    close: true

  render: ->
    {from, target, paths, text} = @props.node

    if text?
      <div className='csm-node text'>
        <div className='text'>TEXT: {text}</div>
      </div>
    else
      klass = new ClassName
        'csm-node path': true
        'no-paths': not paths.length

      <div className={klass}>
        {
          if paths.length
            if @state.close
              <a href='javascript:;' className='toggle' onClick={@toggle}>
                <i className='icon chevron right' />
              </a>
            else
              <a href='javascript:;' className='toggle' onClick={@toggle}>
                <i className='icon chevron down' />
              </a>
        }
        <div className='from'>FROM: {from}</div>
        <div className='target'>TARGET: {target}</div>
        {
          if @state.close and paths.length
            <div className='paths closed'>...</div>
          else
            <div className='paths'>
            {
              for path, idx in paths
                <PathNodesNav key={idx} nodes={path.nodes} />
            }
            </div>
        }
      </div>

  toggle: ->
    @setState close: not @state.close
