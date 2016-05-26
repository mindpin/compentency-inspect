@EssayTestWare = React.createClass
  getInitialState: ->
    answer: @props.data.answer

  render: ->
    <div className="ui form">
      <p>
        {@props.data.content}
      </p>

      <br />

      <div className="field">
        <textarea rows=20 onBlur={@handleAnswer} defaultValue={@state.answer}></textarea>
      </div>
    </div>

  handleAnswer: (evt)->
    @setState
      answer: evt.target.value

    jQuery.ajax
      url: "/test_wares/save_answer"
      type: "POST"
      data:
        id: @props.data.id
        answer: evt.target.value
      dataType: "json"
      success: (res) =>
        console.log res
