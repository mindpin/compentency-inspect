marked.setOptions {
  highlight: (code, lang, callback)->
    hljs.highlightAuto(code).value
}

@QuestionContent = React.createClass
  componentDidMount: ->
    $that = jQuery(ReactDOM.findDOMNode(@))
    mark = marked($that.find(".content").text())
    $that.find(".content").html(mark)

  render: ->
    <div className='ui segment'>
      <div>{@props.data.content_format}</div>
      <div className="content">{@props.data.content}</div>
    </div>
