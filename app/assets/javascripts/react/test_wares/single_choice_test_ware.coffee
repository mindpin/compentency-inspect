@SingleChoiceTestWare = React.createClass
  getInitialState: ->
    answer: @props.data.answer

  render: ->
    input_attrs = {}
    @props.data.choices.map (choice, index)=>
      if choice.id == @state.answer
        input_attrs[choice.id] = {checked: "checked"}

    <div className='single-choice ui form' ref='form'>
      <div className='grouped fields'>
        <label className='content'>{@props.data.content}</label>
        {
          @props.data.choices.map (arr, index)=>
            <div className='field' key={index}>
              <div className="ui radio checkbox">
                <input 
                  type='radio'
                  className='hidden'
                  name={@props.data.id} 
                  value={arr.id} 
                  onChange={->} 
                  {...input_attrs[arr.id]} 
                />
                <label>{arr.text}</label>
              </div>
            </div>
        }
      </div>
    </div>

  handleAnswer: (evt)->
    value = jQuery("input[name='#{@props.data.id}']:checked").val()
    @setState answer: value
    @props.on_answer_change(@props.data.id, value)

  componentDidMount: ->
    jQuery ReactDOM.findDOMNode @refs.form
      .find('.ui.checkbox')
      .checkbox {
        onChange: @handleAnswer
      }