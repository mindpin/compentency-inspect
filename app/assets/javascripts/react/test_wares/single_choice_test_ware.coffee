@SingleChoiceTestWare = React.createClass
  render: ->
    <div className="ui form">
      <div>
        {
          @props.data.content
        }
      </div>

      <br />

      <div className="field">
        {
          @props.data.choices.map (arr, index)=>
              <div className="ui radio" key={index}>
                <input type="radio" name="result" className="hidden" value={arr["id"]} />
                <label>{arr["text"]}</label>
              </div>
        }
      </div>
    </div>
