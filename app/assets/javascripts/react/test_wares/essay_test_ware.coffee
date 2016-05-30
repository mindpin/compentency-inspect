@EssayTestWare = React.createClass
  getInitialState: ->
    answer: @props.data.answer

  render: ->
    <div className="ui form essay">
      <label className='content'>{@props.data.content}</label>
      <div className="field">
        <textarea rows=10 onBlur={@handleAnswer} defaultValue={@state.answer}></textarea>
      </div>
    </div>

  handleAnswer: (evt)->
    @setState answer: evt.target.value
    @props.on_answer_change(@props.data.id, evt.target.value)
