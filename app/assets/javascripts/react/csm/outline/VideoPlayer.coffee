@VideoPlayer = React.createClass
  render: ->
    <div className='video-player'>
      <div className='video-player-inner'>
        <video controls="controls">
          <source src={@props.src} type="video/mp4" />
        </video>
      </div>
    </div>
  