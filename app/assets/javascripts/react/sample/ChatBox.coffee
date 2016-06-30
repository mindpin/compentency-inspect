@ChatBox = React.createClass
  getInitialState: ->
    messages: @props.data.messages

  render: ->
    message_input_area_data =
      send_message_text: @send_message_text

    <div className="chat-box">
      <MessageList data={@state.messages}/>
      <MessageInputArea data={message_input_area_data} ref="message_input_area"/>
    </div>

  
  send_message_text: (e)->
     message_text = @refs.message_input_area.refs.message_input.value
     message =
      chater: 
        id: 1
        name: "我"
      text: message_text
     message_array = @state.messages
     message_array.push(message) 
     @setState
        messages: message_array
     @return_message(message_text,message_array)

   return_message: (message_text,message_array)->
      jQuery.ajax
        url: @props.data.post_url
        type: "POST"
        data: {text: message_text}
      .done (data)=>
        message_array.push(data)
        @setState
          messages: message_array
        jQuery(".message-list").scrollTop(jQuery(".message-list")[0].scrollHeight)
      

MessageList = React.createClass
  render: ->
    <div className="message-list">
      {
        for item in @props.data
          if item.chater.id == 1 then textclass = "left-message"
          if item.chater.id == 2 then textclass = "right-message"
          <div className=textclass key={item.text}>
             <div className="chater">{item.chater.name}:</div>
             <div className="text">  {item.text}</div>
          </div>  
      }
    </div>


MessageInputArea = React.createClass
  render: ->
    <div className="text-input ui massive action input">
      <input type="text" placeholder="输入你想说的话" ref="message_input"/>
      <button className="ui button" onClick={@props.data.send_message_text}>发送</button>
    </div>

