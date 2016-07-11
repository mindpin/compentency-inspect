@SpecialistAnswerQuestion = React.createClass
  render: ->
    <div className="specialist-answer-question">
      <div className="head">
      专业答题
      </div>
      <div className="creator">
        <div className="name">{@props.data.creator}</div>
      </div>
      <div className="content">
        {@props.data.question}
      </div>
      <div className="keywords">
        {
          for keyword in @props.data.keywords
            <a className="ui label transition visible">
              {keyword}
            </a>
        }
      </div>
      <div className="answer">
        <div className="bar">
          <i className="bold icon"></i>
          <i className="font icon"></i>
          <i className="italic icon"></i>
          <i className="quote left icon"></i>
          </div>
        <textarea placeholder="进行解答" />
        <a className="ui button">解答</a>
      </div>
    </div>
