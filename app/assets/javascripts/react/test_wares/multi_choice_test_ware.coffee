@MultiChoiceTestWare = React.createClass
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
            <label key={index}>
              <input type="checkbox" name="result" value={arr["id"]} />
              <label>{arr["text"]}</label>
            </label>
        }
      </div>
    </div>
