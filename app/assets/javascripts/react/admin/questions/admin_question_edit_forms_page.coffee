@AdminQuestionsEditMultiChoicePage = React.createClass
  submit: (evt)->
    jQuery.ajax
      type: 'PUT'
      url: @props.data.submit_url
      data:
        question:
          kind: "multi_choice"
          level: 1
          content: @state.content
          answer:
            choices: @state.choices
            corrects: @state.corrects
    .done (res)=>
      @done res
    .fail (res)=>
      alert res

  handleChoiceBlur: (val)->
    (evt)=>
      choices = @state.choices
      choices = for choice in choices
        choice["text"] = evt.target.value if choice["id"] == val
        choice
      @setState
        choices: choices

  handleContentBlur: (evt)->
    @setState
      content: evt.target.value

  handleCorrectsChange: (val)->
    (evt)=>
      corrects = @state.corrects
      console.log corrects
      i = corrects.indexOf(val)
      console.log i
      if evt.target.checked
        corrects.push(val) if i < 0
      else
        corrects.splice(i, 1) if i >= 0
      console.log corrects
      @setState
        corrects: corrects

  addChoice: ->
    choices = @state.choices
    choices.push
      id: jQuery.randstr(8)
      text: ""
    @setState
      choices: choices

  getInitialState: ->
    content: @props.data.question.content
    choices: @props.data.question.admin_answer["choices"]
    corrects: @props.data.question.admin_answer["corrects"]

  render: ->
    <div className="ui segment">
      <div className="data-form">
        <div className="ui small form">
          <div className="field">
            <label style={{width: "6rem"}}>
              <span className="required">* </span>
              <span>题目内容：</span>
            </label>
            <div className="wrapper" style={{flex: "1 1 0%"}}>
              <textarea rows="5" onBlur={@handleContentBlur} defaultValue={@state.content}>
              </textarea>
            </div>
          </div>
          <div className="field">
            <label style={{width: "6rem"}}>
              <span className="required">* </span>
              <span>答案：</span>
            </label>
            <div className="wrapper" style={{flex: "1 1 0%"}}>
              {
                for choice in @state.choices
                  value = choice["id"]
                  text = choice["text"]
                  checked = false
                  for correct in @state.corrects
                    checked = true if correct == value
                  <div key={value}>
                    <input type="checkbox" name="corrects" checked={checked} value={value} onChange={@handleCorrectsChange(value)} />
                    <input type="text" defaultValue={text} onBlur={@handleChoiceBlur(value)} />
                  </div>
              }
            </div>
          </div>
          <div className="field">
            <div className="ui button icon" onClick={@addChoice}>
              <i className="icon plus"></i>
              添加一个选项
            </div>
          </div>
          <div className="field">
            <label style={{width: "6rem"}}>
              <span>
              </span>
            </label>
            <div className="wrapper" style={{flex: "1 1 0%"}}>
              <a className="ui button green" href="javascript:;" onClick={@submit}>
                <i className="icon check">
                </i>
                确定保存
              </a>
              <a className="ui button" href="javascript:;" onClick={@cancel}>取消</a>
            </div>
          </div>
        </div>
      </div>
    </div>

  done: (res)->
    Turbolinks.visit @props.data.cancel_url

  cancel: ->
    Turbolinks.visit @props.data.cancel_url


@AdminQuestionsEditSingleChoicePage = React.createClass
  submit: (evt)->
    jQuery.ajax
      type: 'PUT'
      url: @props.data.submit_url
      data:
        question:
          kind: "single_choice"
          level: 1
          content: @state.content
          answer:
            choices: @state.choices
            correct: @state.correct
    .done (res)=>
      @done res
    .fail (res)=>
      alert res

  handleChoiceBlur: (val)->
    (evt)=>
      choices = @state.choices
      choices = for choice in choices
        choice["text"] = evt.target.value if choice["id"] == val
        choice
      console.log choices
      @setState
        choices: choices

  handleContentBlur: (evt)->
    @setState
      content: evt.target.value

  handleCorrectClick: (evt)->
    @setState
      correct: evt.target.value

  addChoice: ->
    choices = @state.choices
    choices.push
      id: jQuery.randstr(8)
      text: ""
    @setState
      choices: choices

  getInitialState: ->
    content: @props.data.question.content
    choices: @props.data.question.admin_answer["choices"]
    correct: @props.data.question.admin_answer["correct"]

  render: ->
    <div className="ui segment">
      <div className="data-form">
        <div className="ui small form">
          <div className="field">
            <label style={{width: "6rem"}}>
              <span className="required">* </span>
              <span>题目内容：</span>
            </label>
            <div className="wrapper" style={{flex: "1 1 0%"}}>
              <textarea rows="5" onBlur={@handleContentBlur} defaultValue={@state.content}>
              </textarea>
            </div>
          </div>
          <div className="field">
            <label style={{width: "6rem"}}>
              <span className="required">* </span>
              <span>答案：</span>
            </label>
            <div className="wrapper" style={{flex: "1 1 0%"}}>
              {
                for choice in @state.choices
                  value = choice["id"]
                  text = choice["text"]
                  checked = @state.correct == value
                  <div key={value}>
                    <input type="radio" name="correct" checked={checked} value={value} onClick={@handleCorrectClick} />
                    <input type="text" defaultValue={text} onBlur={@handleChoiceBlur(value)} />
                  </div>
              }
            </div>
          </div>
          <div className="field">
            <div className="ui button icon" onClick={@addChoice}>
              <i className="icon plus"></i>
              添加一个选项
            </div>
          </div>
          <div className="field">
            <label style={{width: "6rem"}}>
              <span>
              </span>
            </label>
            <div className="wrapper" style={{flex: "1 1 0%"}}>
              <a className="ui button green" href="javascript:;" onClick={@submit}>
                <i className="icon check">
                </i>
                确定保存
              </a>
              <a className="ui button" href="javascript:;" onClick={@cancel}>取消</a>
            </div>
          </div>
        </div>
      </div>
    </div>

  done: (res)->
    Turbolinks.visit @props.data.cancel_url

  cancel: ->
    Turbolinks.visit @props.data.cancel_url


@AdminQuestionsEditBoolPage = React.createClass
  render: ->
    {
      TextAreaField
      SelectField
      Submit
    } = DataForm

    layout =
      label_width: '6rem'

    selects = 
      "true": "正确"
      "false": "错误"

    @props.data.question["answer"] = @props.data.question["admin_answer"]

    <div className='ui segment'>
      <SimpleDataForm
        model='question'
        put={@props.data.submit_url}
        data={@props.data.question}
        done={@done}
        cancel={@cancel}
      >
        <TextAreaField {...layout} label='题目内容：' name='content' required />
        <SelectField {...layout} label='答案：' name='answer' required values={selects} />
        <Submit {...layout} text='确定保存' with_cancel='取消' />
      </SimpleDataForm>
    </div>

  done: (res)->
    Turbolinks.visit @props.data.cancel_url

  cancel: ->
    Turbolinks.visit @props.data.cancel_url

@AdminQuestionsEditEssayPage = React.createClass
  render: ->
    {
      TextAreaField
      Submit
    } = DataForm

    layout =
      label_width: '6rem'

    @props.data.question["answer"] = @props.data.question["admin_answer"]

    <div className='ui segment'>
      <SimpleDataForm
        model='question'
        put={@props.data.submit_url}
        data={@props.data.question}
        done={@done}
        cancel={@cancel}
      >
        <TextAreaField {...layout} label='题目内容：' name='content' required />
        <TextAreaField {...layout} label='参考答案：' name='answer' required />
        <Submit {...layout} text='确定保存' with_cancel='取消' />
      </SimpleDataForm>
    </div>

  done: (res)->
    Turbolinks.visit @props.data.cancel_url

  cancel: ->
    Turbolinks.visit @props.data.cancel_url

@AdminQuestionsEditFileUploadPage = React.createClass
  render: ->
    {
      TextAreaField
      Submit
    } = DataForm

    layout =
      label_width: '6rem'

    @props.data.question["answer"] = @props.data.question["admin_answer"]

    <div className='ui segment'>
      <SimpleDataForm
        model='question'
        put={@props.data.submit_url}
        data={@props.data.question}
        done={@done}
        cancel={@cancel}
      >
        <TextAreaField {...layout} label='题目内容：' name='content' required />
        <TextAreaField {...layout} label='参考答案：' name='answer' required />
        <Submit {...layout} text='确定保存' with_cancel='取消' />
      </SimpleDataForm>
    </div>

  done: (res)->
    Turbolinks.visit @props.data.cancel_url

  cancel: ->
    Turbolinks.visit @props.data.cancel_url




