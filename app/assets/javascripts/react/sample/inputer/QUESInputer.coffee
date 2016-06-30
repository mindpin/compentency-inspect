@QUESInputer = React.createClass
  getInitialState: ->
    current_object: @props.data[0]
    stack: [@props.data[0]]
    records: []

  render: ->
    <div className='QUES-inputer'>
      <Records records={@state.records} />
      <Stack stack={@state.stack} />

      <div className='area'>
        <CurrentObject object={@state.current_object} />
        <CurrentObjectFacts facts={@state.current_object.facts} into={@into} />
        <CurrentFactTags tags={@state.current_object.tags} into={@into} />
      </div>
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

Stack = React.createClass
  render: ->
    <div className='stack'>
    {
      for object, idx in @props.stack
        name = object.object_name || object.fact_name || object.tag_name
        klass = new ClassName
          'object': true
          'tag': object.tag_name?
        <div key={idx} className={klass}>{name}</div>
    }
    </div>


CurrentObject = React.createClass
  render: ->
    <div className='current_object'>
      <a className='circle' href='javascript:;' /> {@get_name()}
    </div>

  get_name: ->
    @props.object.object_name ||
    @props.object.fact_name

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

Records = React.createClass
  render: ->
    <div>
    {
      for stack, idx in @props.records
        <Stack key={idx} stack={stack} />
    }
    </div>