@ChatBox = React.createClass
  getInitialState: ->
    messages: @props.data.messages

  render: ->
    message_list_data =
      chater_self: @props.data.chater_self
      messages: @state.messages

    message_input_area_data =
      send_message_text: @send_message_text

    <div className="chat-box">
      <MessageList data={message_list_data}/>
      <MessageInputArea data={message_input_area_data} ref="message_input_area"/>
    </div>

  send_message_text: ()->
     message_text = @refs.message_input_area.refs.message_input.value
     message =
      chater:
        id: @props.data.chater_self.id
        name: @props.data.chater_self.name
      text: message_text
     message_array = @state.messages
     message_array.push(message)
     @setState
        messages: message_array
     @return_message(message_text,message_array)
     @refs.message_input_area.refs.message_input.value = ""

   return_message: (message_text,message_array)->
      jQuery.ajax
        url: @props.data.post_url
        type: "POST"
        data: {text: message_text}
      .done (data)=>
        message_array.push(data)
        @setState
          messages: message_array
        dom = ReactDOM.findDOMNode(@)
        message_list = jQuery(dom).find(".message-list")
        message_list.scrollTop(message_list[0].scrollHeight)

MessageList = React.createClass
  render: ->
    <div className="message-list">
      {
        for item, index in @props.data.messages
          replace_text = item.text.replace(/\r?\n/g, "</br>")
          message_text = {__html: replace_text}

          chater_self = @props.data.chater_self
          if item.chater.id == chater_self.id && item.chater.name == chater_self.name
            textclass = "right-message"
          else
            textclass = "left-message"

          key = "#{index}:#{item.text}"
          <div className=textclass key={key}>
             <div className="chater">{item.chater.name}:</div>
             <div className="text" dangerouslySetInnerHTML={message_text} />
          </div>
      }
    </div>

MessageInputArea = React.createClass
  render: ->
    <div className="text-input">
      <div className="textarea">
        <textarea type="text" placeholder="输入你想说的话" ref="message_input" onKeyDown={@textarea_keydown} onKeyUp={@textarea_keyup}/>
      </div>
      <button className="ui button" onClick={@props.data.send_message_text}>发送</button>
    </div>

  textarea_keyup: (e)->
    @input_keycodes = []

  textarea_keydown: (e)->
    @input_keycodes ||= []
    @input_keycodes[e.keyCode] = true
    if @input_keycodes[13] && @input_keycodes[17]
      @props.data.send_message_text()
