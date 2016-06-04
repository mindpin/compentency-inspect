@AdminQuestionsNewMultiChoicePage = React.createClass
  submit: (evt)->
    choices = ({"id": val, "text": text} for val, text of @state.choices)
    jQuery.ajax
      type: 'POST'
      url: @props.data.submit_url
      data:
        question:
          kind: "multi_choice"
          level: 1
          content: @state.content
          answer:
            choices: choices
            corrects: @state.corrects
    .done (res)=>
      @done res
    .fail (res)=>
      alert res

  handleChoiceBlur: (val)->
    (evt)=>
      choices = @state.choices
      choices[val] = evt.target.value
      @setState
        choices: choices

  handleContentBlur: (evt)->
    @setState
      content: evt.target.value

  handleCorrectsChange: (val)->
    (evt)=>
      corrects = @state.corrects
      i = corrects.indexOf(val)
      if evt.target.checked
        corrects.push(val) if i < 0
      else
        corrects.splice(i, 0) if i >= 0
      @setState
        corrects: corrects

  addChoice: ->
    choices = @state.choices
    choices[jQuery.randstr(8)] = ""
    @setState
      choices: choices

  getInitialState: ->
    choices = {}
    choices[jQuery.randstr(8)] = ""
    choices[jQuery.randstr(8)] = ""
    content: ""
    choices: choices
    corrects: []

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
                for value, text of @state.choices
                  <div key={value}>
                    <input type="checkbox" name="corrects" checked={@state.corrects[value]} value={value} onChange={@handleCorrectsChange(value)} />
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


@AdminQuestionsNewSingleChoicePage = React.createClass
  submit: (evt)->
    choices = ({"id": val, "text": text} for val, text of @state.choices)
    jQuery.ajax
      type: 'POST'
      url: @props.data.submit_url
      data:
        question:
          kind: "single_choice"
          level: 1
          content: @state.content
          answer:
            choices: choices
            correct: @state.correct
    .done (res)=>
      @done res
    .fail (res)=>
      alert res

  handleChoiceBlur: (val)->
    (evt)=>
      choices = @state.choices
      choices[val] = evt.target.value
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
    choices[jQuery.randstr(8)] = ""
    @setState
      choices: choices

  getInitialState: ->
    choices = {}
    choices[jQuery.randstr(8)] = ""
    choices[jQuery.randstr(8)] = ""
    content: ""
    choices: choices
    correct: null

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
                for value, text of @state.choices
                  <div key={value}>
                    <input type="radio" name="correct" checked={@state.correct == value} value={value} onClick={@handleCorrectClick} />
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


@AdminQuestionsNewBoolPage = React.createClass
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

    <div className='ui segment'>
      <SimpleDataForm
        model='question'
        post={@props.data.submit_url}
        data={
          {
            kind: "bool"
            level: 1
          }
        }
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

@AdminQuestionsNewEssayPage = React.createClass
  render: ->
    {
      TextAreaField
      Submit
    } = DataForm

    layout =
      label_width: '6rem'

    <div className='ui segment'>
      <SimpleDataForm
        model='question'
        post={@props.data.submit_url}
        data={
          {
            kind: "essay"
            level: 1
          }
        }
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

@AdminQuestionsNewFileUploadPage = React.createClass
  render: ->
    {
      TextAreaField
      Submit
    } = DataForm

    layout =
      label_width: '6rem'

    <div className='ui segment'>
      <SimpleDataForm
        model='question'
        post={@props.data.submit_url}
        data={
          {
            kind: "file_upload"
            level: 1
          }
        }
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



