@VideoPlayer = React.createClass
  render: ->
    <div className="video-player-page" >
      
      <video className="video-player" controls="controls">
        <source src={@props.data} type="video/mp4" />
      </video>
    </div>
  