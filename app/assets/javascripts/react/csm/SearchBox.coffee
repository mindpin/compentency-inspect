@SearchBox = React.createClass
  getInitialState: ->
    current_words: @props.data.current_words
    recommend_words: @props.data.recommend_words
    results: @props.data.results

  render: ->
    search_bar_data =
      current_words: @state.current_words
      search_bar_input_key_down: @search_bar_input_key_down
      delete_word_form_current_words: @delete_word_form_current_words

    recommend_words_list_data =
      recommend_words: @state.recommend_words
      add_word_to_current_words: @add_word_to_current_words

    <div className="search-box">
      <SearchBar data={search_bar_data}/>
      <RecommendWordsList data={recommend_words_list_data} />
      {
        if @state.results.length == 0 && @state.current_words.length != 0
          <CreateQuestionBox data={dashboard_url: @props.data.dashboard_url} />
        else
          <ResultsList data={@state.results} />
      }
    </div>


  search_bar_input_key_down: (e)->
    switch e.keyCode
      when 8
        if e.target.value == ""
          @delete_last_current_words()
      when 32
        word = e.target.value.replace(new RegExp(" ", 'g'), "")
        if word != ""
          target = e.target
          clear_input = ()->
            target.value = ""
          setTimeout clear_input, 0
          @add_word_to_current_words(word)

  add_word_to_current_words: (word)->
    current_words = @state.current_words
    if current_words.indexOf(word) == -1
      current_words.push(word)
      @setState
        current_words: current_words
      @post_search()

  delete_word_form_current_words: (word)->
    current_words = @state.current_words
    index = current_words.indexOf(word)
    if index != -1 then current_words.splice(index, 1)
    @setState
      current_words: current_words
    @post_search()

  delete_last_current_words: (e)->
    current_words = @state.current_words
    current_words.pop()
    @setState
      current_words: current_words
    @post_search()

  post_search: ()->
    jQuery.ajax
      url: @props.data.search_url
      type: 'POST'
      data:
        keywords: @state.current_words
    .done (data)=>
      @setState
        recommend_words: data.recommend_words
        results: data.results

SearchBar = React.createClass
  render: ->
    <div className="search-bar">
      <div className="search-input" onClick={@focus_input}>
        {
          for item in @props.data.current_words
            <a className="ui label transition visible" key={item}>
              {item}
              <i className="delete icon" onClick={@delete_word(item)}></i>
            </a>
        }
        <input type="text" placeholder="输入搜索关键词" onKeyDown={@props.data.search_bar_input_key_down} />
        <i className="search icon"></i>
      </div>
    </div>

  delete_word: (word)->
    =>
      @props.data.delete_word_form_current_words(word)

  focus_input: (e)->
    div = jQuery(e.target)
    if div.hasClass("search-input")
      div.find("input").focus()

RecommendWordsList = React.createClass
  render: ->
    <div className="recommend-words-list">
    {
      for item in @props.data.recommend_words
        <span className="word" key={item} onClick={@add_word(item)}>
        {item}
        </span>
    }
    </div>

  add_word: (word)->
    =>
      @props.data.add_word_to_current_words(word)

ResultsList = React.createClass
  render: ->
    <div className="results-list">
      {
        for item in @props.data
          <div className="result-item" key={item.title}>
            <div className="title">{item.title}</div>
            <div className="desc">{item.desc}</div>
          </div>
      }
    </div>

CreateQuestionBox = React.createClass
  getInitialState: ->
    status: "uncreate"

  render: ->
    <div className="create-question-box">
    {
      switch @state.status
        when "uncreate" then @uncreate_content()
        when "creating" then @creating_content()
        when "created"  then @created_content()
    }
    </div>

  uncreate_content: ->
    <div className="uncreate">
      没有找到相关资料，
      <a className="ui button" onClick={@open_question_form}>点击创建问题</a>
    </div>

  creating_content: ->
    <div className="creating">
      <textarea placeholder="输入问题内容" />
      <a className="ui button" onClick={@create_question}>创建</a>
    </div>

  created_content: ->
    <div className="created">
      创建成功，
      <a className="ui button" href={@props.data.dashboard_url}>点击进入个人中心</a>
    </div>

  open_question_form: ->
    @setState
      status: "creating"
  create_question: (evt)->
    evt.preventDefault()
    @setState
      status: "created"
