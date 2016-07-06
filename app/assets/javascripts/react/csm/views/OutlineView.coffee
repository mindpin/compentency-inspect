@OutlineView = React.createClass
  render: ->
    <div>
      <PathNodesNav nodes={@props.data} />
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