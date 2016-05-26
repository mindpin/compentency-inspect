@MultiChoiceTestWare = React.createClass
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
            checked = false
            checked = true if @props.data.answer.indexOf(arr["id"]) >= 0
            <label key={index}>
              <input type="checkbox" name={@props.data.id} value={arr["id"]} onChange={@handleAnswer} checked={checked} />
              {arr["text"]}
            </label>
        }
      </div>
    </div>

  handleAnswer: (evt)->
    $values = jQuery("input[name='#{@props.data.id}']:checked").map (i)-> @value
    values = $values.toArray()
    jQuery.ajax
      url: "/test_wares/#{@props.data.id}/answer"
      type: "POST"
      data:
        answer: values
      dataType: "json"
      success: (res) =>
        console.log res

