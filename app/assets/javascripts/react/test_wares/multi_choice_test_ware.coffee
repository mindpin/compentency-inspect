@MultiChoiceTestWare = React.createClass
  getInitialState: ->
    answer: @props.data.answer

  render: ->
    input_attrs = {}
    @props.data.choices.map (choice, index)=>
      if @state.answer.indexOf(choice.id) != -1
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
            <label key={index}>
              <input type="checkbox" name={@props.data.id} value={arr.id} onChange={@handleAnswer} {...input_attrs[arr.id]} />
              {arr.text}
            </label>
        }
      </div>
    </div>

  handleAnswer: (evt)->
    $values = jQuery("input[name='#{@props.data.id}']:checked").map (i)-> @value
    values = $values.toArray()

    @setState
      answer: values

    jQuery.ajax
      url: "/test_wares/#{@props.data.id}/answer"
      type: "POST"
      data:
        answer: values
      dataType: "json"
      success: (res) =>
        console.log res
