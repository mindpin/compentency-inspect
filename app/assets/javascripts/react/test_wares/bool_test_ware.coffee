@BoolTestWare = React.createClass
  getInitialState: ->
    answer: @props.data.answer

  render: ->
    true_input_attr  = {}
    false_input_attr = {}
    if @state.answer == true
      true_input_attr.checked = "checked"
    if @state.answer == false
      false_input_attr.checked = "checked"


    <div className='bool ui form'>
      <div className='grouped fields'>
        <label className='content'>{@props.data.content}</label>

        <div className="field">
          <div className="ui radio checkbox">
            <input type="radio" value="true" onChange={@handleAnswer} {...true_input_attr}/>
            <label>正确</label>
          </div>
        </div>

        <div className="field">
          <div className="ui radio checkbox">
            <input type="radio" value="false" onChange={@handleAnswer} {...false_input_attr}/>
            <label>错误</label>
          </div>
        </div>
      </div>
    </div>

  handleAnswer: (evt)->
    value = false
    value = true if evt.target.value == "true"

    @setState answer: value
    @props.on_answer_change(@props.data.id, value)
