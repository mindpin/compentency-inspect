@SingleChoiceTestWare = React.createClass
  getInitialState: ->
    answer: @props.data.answer

  render: ->
    input_attrs = {}
    @props.data.choices.map (choice, index)=>
      if choice.id == @state.answer
        input_attrs[choice.id] = {checked: "checked"}

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
              <input type="radio" name={@props.data.id} className="hidden" value={arr.id} onChange={@handleAnswer} {...input_attrs[arr.id]} />
              <label>{arr.text}</label>
            </div>
        }
      </div>
    </div>

  handleAnswer: (evt)->
    @setState
      answer: evt.target.value

    jQuery.ajax
      url: "/test_wares/#{@props.data.id}/answer"
      type: "POST"
      data:
        answer: evt.target.value
      dataType: "json"
      success: (res) =>
        console.log res
