@BoolTestWare = React.createClass
  render: ->
    <div className="ui form">
      <div>
        {
          @props.data.content
        }
      </div>

      <br />

      <div className="field">
        <div className="ui radio">
          <input type="radio" name="result" className="hidden" value="true" onChange={@handleAnswer} />
          <label>对</label>
        </div>
      </div>
      <div className="field">
        <div className="ui radio">
          <input type="radio" name="result" className="hidden" value="false" onChange={@handleAnswer} />
          <label>错</label>
        </div>
      </div>
    </div>

  handleAnswer: (evt)->
    value = false
    value = true if evt.target.value == "true"

    jQuery.ajax
      url: "/test_wares/#{@props.data.id}/answer"
      type: "POST"
      data:
        answer: value
      dataType: "json"
      success: (res) =>
        console.log res

