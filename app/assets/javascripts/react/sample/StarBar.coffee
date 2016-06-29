@StarBar = React.createClass
  getInitialState: ->
    curent_star_count: @props.data.curent_star_count

  render: ->
    <div className="star-bar">
      {
        for star in [1..@props.data.total_star_count]
          if star <= @state.curent_star_count
            <a href = "javascript:;" key={star}>
             <i className="star icon light" onClick={@update_star(star)}></i>
            </a>
          else
            <a href = "javascript:;" key={star}>
              <i className="star icon" onClick={@update_star(star)}></i>
            </a>
      }
    </div>

  update_star: (star)->
    =>
      @update_star_curent_count(star)

  update_star_curent_count: (star)->
    jQuery.ajax
      url: @props.data.post_url
      type: "POST"
      data:
        star_count: star
    .done (data)=>
      @setState
        curent_star_count: data.curent_star_count
    