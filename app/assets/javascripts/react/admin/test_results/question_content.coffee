marked.setOptions {
  highlight: (code, lang, callback)->
    hljs.highlightAuto(code).value
}

@QuestionContent = React.createClass
  # propTypes:
  #   content_format: React.PropTypes.string.isRequired
  #   content:        React.PropTypes.string.isRequired

  render: ->
    switch @props.data.content_format
      when 'text'
        content = @props.data.content
        <div className="content text">{content}</div>
      when 'md'
        content = 
          __html: marked(@props.data.content)
        <div className="content markdown" dangerouslySetInnerHTML={content} />
    