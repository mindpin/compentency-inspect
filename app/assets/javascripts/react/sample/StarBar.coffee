@StarBar = React.createClass
  getInitialState: ->
    curent_star_count: @props.data.curent_star_count
    curent_moves_over_count: 0

  render: ->

    <div className="star-bar">
      {
        if @state.curent_star_count==undefined then @state.curent_star_count = 0
        for star in [1..@props.data.total_star_count]
          if @state.curent_moves_over_count != 0
            light_count = @state.curent_moves_over_count
          else
            light_count = @state.curent_star_count
          star_data =
            light: star <= light_count
            update_star_count: @update_star_curent_count
            change_star_count: @change_star_count
            star_state_count: @state.curent_star_count
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
        curent_star_count: data.curent_star_count

  change_star_count: (count)->
    @setState
      curent_moves_over_count: count

Star = React.createClass
  render: ->
    <div className="star">
      <a href="javascript:;" onClick={@update_star()} onMouseOut={@onMouseout()} onMouseOver={@onMouseOver()}>
        <i className="star icon #{@class_name()}"></i>
      </a>
    </div>

  update_star: ()->
    =>
      @props.data.update_star_count(@props.data.star_num)

  class_name: ()->
    if @props.data.light then "light" else ""

  onMouseOver: ()->
    =>
      @props.data.change_star_count(@props.data.star_num)

  onMouseout: ()->
    =>
      @props.data.change_star_count(@props.data.star_state_count)