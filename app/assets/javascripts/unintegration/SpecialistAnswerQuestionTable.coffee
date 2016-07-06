@SpecialistAnswerQuestionTable = React.createClass
  getInitialState: ->
    filter_words: []

  render: ->
    filter_bar_data =
      filter_words: @state.filter_words
      filter_bar_input_key_down: @filter_bar_input_key_down
      delete_word_form_filter_words: @delete_word_form_filter_words

    table_data =
      items: @get_filter_questions()
      add_word_to_filter_words: @add_word_to_filter_words
      edit_url: "/unintegration/specialist_answer_question"

    <div className="specialist-answer-question-table">
      <SpecialistAnswerQuestionTable.FilterBar data={filter_bar_data} />
      <SpecialistAnswerQuestionTable.Table data={table_data} />
    </div>

  get_filter_questions: ->
    @props.data.filter (question)=>
      for keyword in @state.filter_words
        if question.keywords.indexOf(keyword) == -1
          return false
      return true

  delete_last_filter_word: ->
    filter_words = @state.filter_words
    filter_words.pop()
    @setState
      filter_words: filter_words

  filter_bar_input_key_down: (e)->
    switch e.keyCode
      when 8
        if e.target.value == ""
          @delete_last_filter_word()
      when 32
        word = e.target.value.replace(new RegExp(" ", 'g'), "")
        if word != ""
          target = e.target
          clear_input = ()->
            target.value = ""
          setTimeout clear_input, 0
          @add_word_to_filter_words(word)

  delete_word_form_filter_words: (word)->
    filter_words = @state.filter_words
    index = filter_words.indexOf(word)
    if index != -1 then filter_words.splice(index, 1)
    @setState
      filter_words: filter_words

  add_word_to_filter_words: (word)->
    filter_words = @state.filter_words
    if filter_words.indexOf(word) == -1
      filter_words.push(word)
      @setState
        filter_words: filter_words

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            question: '问题'
            creator:  '提问者'
            keywords: '关键词'
            status:   '状态'
            actions:  '操作'
          data_set: @props.data.items.map (x)=>
            actions = switch x.status
              when "未解答"
                <div>
                  <a className="ui button mini blue basic" href={@props.data.edit_url}>
                    <i className='icon write' />
                    解答
                  </a>
                </div>
              when "已解答"
                <div>
                  <a className="ui button mini blue basic" href="">
                    <i className='icon write' />
                    发布
                  </a>
                </div>
              else
                null

            keywords =
              <div>
              {
                for item in x.keywords
                  <a className="ui label transition visible"  onClick={@add_word(item)}>
                    {item}
                  </a>
              }
              </div>

            {
              id: x.question
              question: x.question
              status: x.status
              creator: x.creator
              actions: actions
              keywords: keywords
            }

          th_classes: {}
          td_classes: {
            actions: 'collapsing'
          }
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='专家答疑' />
        </div>

      add_word: (word)->
        =>
          @props.data.add_word_to_filter_words(word)

    FilterBar: React.createClass
      render: ->
        <div className="filter-bar">
          <div className="filter-input" onClick={@focus_input}>
            {
              for item in @props.data.filter_words
                <a className="ui label transition visible" key={item}>
                  {item}
                  <i className="delete icon" onClick={@delete_word(item)}></i>
                </a>
            }
            <input type="text" placeholder="过滤关键词" onKeyDown={@props.data.filter_bar_input_key_down} />
          </div>
        </div>

      delete_word: (word)->
        =>
          @props.data.delete_word_form_filter_words(word)

      focus_input: (e)->
        div = jQuery(e.target)
        if div.hasClass("filter-input")
          div.find("input").focus()
