@SingleChoiceTestWare = React.createClass
  render: ->
    <div className="ui form">
      <div>
        {
          @props.data.content
        }
      </div>

      <br />

      <div className="field">
        {
          @props.data.choices.map (arr, index)=>
              <div className="ui radio" key={index}>
                <input type="radio" name={@props.data.id} className="hidden" value={arr["id"]} onChange={@handleAnswer} checked={arr["id"] == @props.data.answer} />
                <label>{arr["text"]}</label>
              </div>
        }
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
