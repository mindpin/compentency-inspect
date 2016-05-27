@SingleChoiceTestWare = React.createClass
  getInitialState: ->
    answer: @props.data.answer

  render: ->
    input_attrs = {}
    @props.data.choices.map (choice, index)=>
      if choice.id == @state.answer
        input_attrs[choice.id] = {checked: "checked"}

    <div className='single-choice ui form'>
      <div className='grouped fields'>
        <label className='content'>{@props.data.content}</label>
        {
          @props.data.choices.map (arr, index)=>
            <div className='field' key={index}>
              <div className="ui radio checkbox" key={index}>
                <input type='radio' value={arr.id} onChange={@handleAnswer} {...input_attrs[arr.id]} />
                <label>{arr.text}</label>
              </div>
            </div>
        }
      </div>
    </div>

  handleAnswer: (evt)->
    @setState answer: evt.target.value
    @props.on_answer_change(@props.data.id, evt.target.value)
