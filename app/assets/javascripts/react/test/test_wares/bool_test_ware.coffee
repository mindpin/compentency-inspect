@BoolTestWare = React.createClass
  getInitialState: ->
    answer: @props.data.answer

  render: ->
    true_input_attr  = {}
    false_input_attr = {}
    if @state.answer == true
      true_input_attr.checked = "checked"
    if @state.answer == false
      false_input_attr.checked = "checked"


    <div className='bool ui form' ref='form'>
      <div className='grouped fields'>
        <QuestionContent data={@props.data} />

        <div className="field">
          <div className="ui radio checkbox">
            <input 
              type="radio"
              className='hidden'
              name={@props.data.id}  
              value="true" 
              onChange={->} 
              {...true_input_attr}
            />
            <label>正确</label>
          </div>
        </div>

        <div className="field">
          <div className="ui radio checkbox">
            <input 
              type="radio" 
              className='hidden'
              name={@props.data.id} 
              value="false" 
              onChange={->} 
              {...false_input_attr}
            />
            <label>错误</label>
          </div>
        </div>
      </div>
    </div>

  handleAnswer: (evt)->
    value = jQuery("input[name='#{@props.data.id}']:checked").val() == 'true'

    @setState answer: value
    @props.on_answer_change(@props.data.id, value)

  componentDidMount: ->
    jQuery ReactDOM.findDOMNode @refs.form
      .find('.ui.checkbox')
      .checkbox {
        onChange: @handleAnswer
      }