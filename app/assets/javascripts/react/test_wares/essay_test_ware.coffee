@EssayTestWare = React.createClass
  getInitialState: ->
    answer: @props.data.answer

  render: ->
    <div className="ui form essay">
      <QuestionContent data={@props.data} />
      <div className="field">
        <textarea 
          rows=10 
          onBlur={@handleAnswer} 
          defaultValue={@state.answer}
          placeholder='在这里填写论述内容'
        />
      </div>
    </div>

  handleAnswer: (evt)->
    @setState answer: evt.target.value
    @props.on_answer_change(@props.data.id, evt.target.value)
