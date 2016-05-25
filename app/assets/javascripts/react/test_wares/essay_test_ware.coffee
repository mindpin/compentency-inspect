@EssayTestWare = React.createClass
  render: ->
    <div className="ui form">
      <p>
        {@props.data.content}
      </p>

      <br />

      <div className="field">
        <textarea rows=20>
        </textarea>
      </div>
    </div>
