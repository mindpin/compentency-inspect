@BoolTestWare = React.createClass
  getInitialState: ->
    answer: @props.data.answer

  render: ->
    true_input_attr  = {}
    false_input_attr = {}
    if @state.answer
      true_input_attr.checked = "checked"
    else
      false_input_attr.checked = "checked"


    <div className="ui form">
      <div>
        {
          @props.data.content
        }
      </div>

      <br />

      <div className="field">
        <div className="ui radio">
          <input type="radio" name={@props.data.id} className="hidden" value="true" onChange={@handleAnswer} {...true_input_attr}/>
          <label>对</label>
        </div>
      </div>
      <div className="field">
        <div className="ui radio">
          <input type="radio" name={@props.data.id} className="hidden" value="false" onChange={@handleAnswer} {...false_input_attr}/>
          <label>错</label>
        </div>
      </div>
    </div>

  handleAnswer: (evt)->
    value = false
    value = true if evt.target.value == "true"

    @setState
      answer: value

    jQuery.ajax
      url: "/test_wares/#{@props.data.id}/answer"
      type: "POST"
      data:
        answer: value
      dataType: "json"
      success: (res) =>
        console.log res
