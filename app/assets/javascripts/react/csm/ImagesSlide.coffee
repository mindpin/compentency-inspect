@ImagesSlide = React.createClass
  getInitialState: ->
    image_urls: []
    current_image_index: null

  render: ->
    if @state.image_urls.length == 0
      <div>图片正在加载中</div>
    else
      <div className='images-slide'>
        <div className='current-image'>
        {
          current_url = @state.image_urls[@state.current_image_index]
          <img src={current_url} />
        }
        </div>
        {
          if @is_first_page()
            klass = 'prev-image disabled'
          else
            klass = 'prev-image'

          <a className={klass} href='javascript:;' onClick={@prev_image}>
            <i className='icon chevron left' />
          </a>
        }
        {
          if @is_last_page()
            klass = 'next-image disabled'
          else
            klass = 'next-image'

          <a className={klass} href='javascript:;' onClick={@next_image}>
            <i className='icon chevron right' />
          </a>
        }
        <div className='pages'>
          {@state.current_image_index + 1} / {@state.image_urls.length}
        </div>
      </div>

  componentDidMount: ->
    jQuery.ajax
      url: "/getimgs"
      data:
        file: @props.resource.file
    .done (res)=>
      @setState 
        image_urls: res
        current_image_index: 0

  prev_image: ->
    # 如果是第一张图片，则前翻时给出提示
    if @is_first_page()
      # alert('已经翻到头了')
      # do nothing
    else
      @setState current_image_index: @state.current_image_index - 1

  next_image: ->
    if @is_last_page()
      # alert('已经翻到尾了')
      # do nothing
    else
      @setState current_image_index: @state.current_image_index + 1

  is_first_page: ->
    @state.current_image_index == 0

  is_last_page: ->
    @state.current_image_index == @state.image_urls.length - 1