@StarBar = React.createClass
  getInitialState: ->
    current_star_count: @props.data.current_star_count
    current_moves_over_count: 0

  render: ->

    <div className="star-bar">
      {
        if @state.current_star_count==undefined then @state.current_star_count = 0
        for star in [1..@props.data.total_star_count]
          if @state.current_moves_over_count != 0
            light_count = @state.current_moves_over_count
          else
            light_count = @state.current_star_count
          star_data =
            light: star <= light_count
            update_star_count: @update_star_curent_count
            change_star_count: @change_star_count
            star_state_count: @state.current_star_count
            star_num: star
          <Star data={star_data} key={star} />
      }
    </div>

  
  update_star_curent_count: (star)->
    jQuery.ajax
      url: @props.data.post_url
      type: "POST"
      data:
        star_count: star
    .done (data)=>
      @setState
        current_star_count: data.current_star_count

  change_star_count: (count)->
    @setState
      current_moves_over_count: count

Star = React.createClass
  render: ->
    <div className="star">
      <a href="javascript:;" onClick={@update_star()} onMouseOut={@on_mouse_out()} onMouseOver={@on_mouse_over()}>
        <i className="star icon #{@class_name()}"></i>
      </a>
    </div>

  update_star: ()->
    =>
      @props.data.update_star_count(@props.data.star_num)

  class_name: ()->
    if @props.data.light then "light" else ""

  on_mouse_over: ()->
    =>
      @props.data.change_star_count(@props.data.star_num)

  on_mouse_out: ()->
    =>
      @props.data.change_star_count(@props.data.star_state_count)