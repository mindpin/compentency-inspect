@MultiChoiceTestWare = React.createClass
  getInitialState: ->
    answer: @props.data.answer

  render: ->
    input_attrs = {}
    @props.data.choices.map (choice, index)=>
      if (@state.answer || []).indexOf(choice.id) != -1
        input_attrs[choice.id] = {checked: "checked"}

    <div className='multi-choice ui form'>
      <div className='grouped fields'>
        <label className='content'>{@props.data.content}</label>
        {
          @props.data.choices.map (arr, index)=>
            <div className='field' key={index}>
              <div className='ui checkbox'>
                <input type="checkbox" name={@props.data.id} value={arr.id} onChange={@handleAnswer} {...input_attrs[arr.id]} />
                <label>{arr.text}</label>
              </div>
            </div>
        }
      </div>
    </div>

  handleAnswer: (evt)->
    $values = jQuery("input[name='#{@props.data.id}']:checked").map (i)-> @value
    values = $values.toArray()

    @setState
      answer: values

    @setState answer: values
    @props.on_answer_change(@props.data.id, values)
