@EditExperienceTargetStructure = React.createClass
  render: ->
    <div className="edit-experience-target-structure">
      <Child data={@props.data} />
    </div>

Child = React.createClass
  render: ->
    <div className="child">
    {
      if @props.data.tag_name
        tag_content_data =
          tag_name: @props.data.tag_name
        <TagContent data={tag_content_data} />
      else
        fact_content_data =
          fact_name: @props.data.fact_name
          children:  @props.data.children
        <FactContent data={fact_content_data} />
    }
    </div>

TagContent = React.createClass
  render: ->
    <div className="tag-content">
      <i className="tag icon"></i>
      <div className="tag-name">{@props.data.tag_name}</div>
    </div>

FactContent = React.createClass
  render: ->
    <div className="fact-content open">
      <div className="content">
        <div className="fact-icon" onClick={@taggle_classname}>
          <i className="angle right icon"></i>
          <i className="angle down icon"></i>
        </div>
        <div className="fact-name"><i className='icon circle thin' style={color: '#69ABDB'} /> {@props.data.fact_name}</div>
      </div>
      <ChildrenList data={@props.data.children} />
    </div>

  taggle_classname: ->
    $div = jQuery(ReactDOM.findDOMNode(@))
    $div.toggleClass("close")
    $div.toggleClass("open")

ChildrenList = React.createClass
  render: ->
    <div className="children-list">
    {
      for child in @props.data
        <Child data={child} />
    }
    </div>
