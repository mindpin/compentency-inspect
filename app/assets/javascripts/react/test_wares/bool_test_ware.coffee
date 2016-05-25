@BoolTestWare = React.createClass
  render: ->
    <div className="ui form">
      <div>
        {
          @props.data.content
        }
      </div>

      <br />

      <div className="field">
        <div className="ui radio">
          <input type="radio" name="result" className="hidden" value="true" />
          <label>对</label>
        </div>
      </div>
      <div className="field">
        <div className="ui radio">
          <input type="radio" name="result" className="hidden" value="false" />
          <label>错</label>
        </div>
      </div>
    </div>
