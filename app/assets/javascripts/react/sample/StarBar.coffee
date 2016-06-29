@StarBar = React.createClass
  getInitialState: ->
    curent_star_count: @props.data.curent_star_count

  render: ->

    <div className="star-bar">
      {
        for star in [1..@props.data.total_star_count]
          star_data =
            light: star <= @state.curent_star_count
            update_star_count: @update_star_curent_count
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

Star = React.createClass
  render: ->
    <div className="star">
      <a href="javascript:;">
        <i className="star icon #{@class_name()}" onClick={@update_star()}></i>
      </a>
    </div>

  update_star: ()->
    =>
      @props.data.update_star_count(@props.data.star_num)

  class_name: ()->
    if @props.data.light then "light" else ""