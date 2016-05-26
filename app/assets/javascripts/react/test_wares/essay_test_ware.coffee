@EssayTestWare = React.createClass
  render: ->
    <div className="ui form">
      <p>
        {@props.data.content}
      </p>

      <br />

      <div className="field">
        <textarea rows=20 onBlur={@handleAnswer}>
        </textarea>
      </div>
    </div>

  handleAnswer: (evt)->
    jQuery.ajax
      url: "/test_wares/#{@props.data.id}/answer"
      type: "POST"
      data:
        answer: evt.target.value
      dataType: "json"
      success: (res) =>
        console.log res

