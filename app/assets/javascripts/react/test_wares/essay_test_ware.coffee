@EssayTestWare = React.createClass
  getInitialState: ->
    answer: @props.data.answer

  render: ->
    <div className="ui form">
      <p>
        <strong>{@props.data.content}</strong>
      </p>
      <div className="field">
        <textarea rows=10 onBlur={@handleAnswer} defaultValue={@state.answer}></textarea>
      </div>
    </div>

  handleAnswer: (evt)->
    @setState answer: evt.target.value
    @props.on_answer_change(@props.data.id, evt.target.value)
