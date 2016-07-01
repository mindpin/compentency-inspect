@QUESInputer = React.createClass
  getInitialState: ->
    current_object: @props.data[0]
    stack: [@props.data[0]]
    records: []

  render: ->
    <div className='QUES-inputer'>
      <Records records={@state.records} />
      <Stack stack={@state.stack} />

      {
        if false
          <div className='area'>
            <CurrentObject object={@state.current_object} />
            <CurrentObjectFacts facts={@state.current_object.facts} into={@into} />
            <CurrentFactTags tags={@state.current_object.tags} into={@into} />
          </div>
        else
          <div className='area'>
            <CurrentObjectD3 object={@state.current_object} into={@into} />
          </div>
      }
    </div>

  into: (fact)->
    =>
      stack = @state.stack
      stack.push fact

      if fact.fact_name?
        @setState
          current_object: fact
          stack: stack
      else
        records = @state.records
        records.push stack

        @setState
          current_object: @props.data[0]
          stack: [@props.data[0]]


get_name_from_object = (object)->
  object.object_name || object.fact_name || object.tag_name

get_children_from_object = (object)->
  object.facts || object.tags

get_color_from_object = (object)->
  return '#2CA02C' if object.object_name?
  return '#AEC7E8' if object.fact_name?
  return '#FFBB78' if object.tag_name?


Records = React.createClass
  render: ->
    <div className='records'>
    {
      for record, idx in @props.records
        <Record key={idx} record={record} />
    }
    </div>

Record = React.createClass
  render: ->
    tags = @props.record.map (object)->
      {
        name: get_name_from_object(object)
        className: if object.tag_name then 'tag-value' else null
      }

    <div className='record'>
      <TagsBar tags={tags} />
    </div>

Stack = React.createClass
  render: ->
    tags = @props.stack.map (object)->
      {
        name: get_name_from_object(object)
        className: if object.tag_name then 'tag-value' else null
      }

    <div className='stack'>
      <TagsBar tags={tags} />
    </div>


CurrentObject = React.createClass
  render: ->
    name = get_name_from_object @props.object

    <div className='current_object'>
      <a className='circle' href='javascript:;' /> {name}
    </div>


CurrentObjectFacts = React.createClass
  render: ->
    if @props.facts?
      h = @props.facts.length * 60

      style =
        height: h
        marginTop: - h / 2

      <div className='facts' style={style}>
      {
        for fact, idx in @props.facts
          <ChildFact key={idx} fact={fact} into={@props.into} />
      }
      </div>
    else
      <div />

ChildFact = React.createClass
  render: ->
    <div className='child-fact'>
      <a className='circle' href='javascript:;' onClick={@props.into(@props.fact)} /> {@props.fact.fact_name}
    </div>

CurrentFactTags = React.createClass
  render: ->
    if @props.tags?
      h = @props.tags.length * 50

      style =
        height: h
        marginTop: - h / 2

      <div className='tags' style={style}>
      {
        for tag, idx in @props.tags
          <ChildTag key={idx} tag={tag} into={@props.into} />
      }
      </div>
    else
      <div />

ChildTag = React.createClass
  render: ->
    <div className='child-tag'>
      <a className='circle' href='javascript:;' onClick={@props.into(@props.tag)} /> {@props.tag.tag_name}
    </div>



CurrentObjectD3 = React.createClass
  render: ->
    graph = @get_graph()

    <D3Force graph={graph} />

  get_graph: ->
    nodes = [@props.object]

    get_children_from_object(@props.object).forEach (child)->
      nodes.push child

    nodes = for node, idx in nodes
      name: get_name_from_object(node)
      color: get_color_from_object(node)
      click: 
        if idx == 0 
        then ->{}
        else @props.into(node)

    links = ({source: 0, target: i} for i in [1...nodes.length])

    {
      nodes: nodes
      links: links
    }
