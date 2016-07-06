@OutlineContent = React.createClass
  getInitialState: ->
    pages = []
    for item in @props.outline_data
      pages.push item
      for sitem in item.children || []
        pages.push sitem

    pages: pages

  render: ->
    pages = @state.pages
    page = pages.filter((x)=> x.id == @props.cid)[0]
    

    <div className='outline-content'>
      <div className='left-part'>
        <SlideArea page={page} ref='slide' />
        <PageTurning pages={pages} page={page} prev={@prev} next={@next} />
      </div>

      <RightPart page={page} ref='rpart' play_video_album={@play_video_album} key={page.id} />

      <div className='bottom'>
        <a className='ui button'>前翻</a>
        <a className='ui button'>后翻</a>
      </div>

      <VideoLayer ref='video_player' />
    </div>

  prev: (page_idx)->
    =>
      prev_id = @state.pages[page_idx - 1].id
      @props.page.nav_to prev_id

  next: (page_idx)->
    =>
      next_id = @state.pages[page_idx + 1].id
      @props.page.nav_to next_id

  componentDidUpdate: ->
    ref_animate @refs.slide, 'animate-slide-down'
    ref_animate @refs.rpart, 'animate-slide-up'

  play_video_album: (album)->
    @refs.video_player.open album


SlideArea = React.createClass
  render: ->
    page = @props.page

    <div className='slide-area'>
      <div className='slide-outer'>
        <div className='slide'>
          <div className='slide-inner'>
            <img src={page.slide} />
          </div>
        </div>
      </div>
    </div>


PageTurning = React.createClass
  render: ->
    pages = @props.pages
    page = @props.page

    first_page = pages[0]
    last_page = pages[pages.length - 1]

    page_idx = pages.indexOf page

    prev_klass = new ClassName
      "prev": true
      "disabled": page == first_page

    next_klass = new ClassName
      "next": true
      "disabled": page == last_page

    <div className='page-turning'>
      <a className={prev_klass} href='javascript:;' onClick={@props.prev(page_idx)}>
        <i className='icon chevron left' /> 上一页
      </a>
      <a className={next_klass} href='javascript:;' onClick={@props.next(page_idx)}>
        下一页 <i className='icon chevron right' />
      </a>
    </div>


RightPart = React.createClass 
  render: ->
    page = @props.page

    <div className='right-part'>
      <h2 className='title'>{page.subname || page.name}</h2>
      <div className='detail'>
        {
          if page.desc?
            desc = __html: marked(page.desc)
            <div className='desc' dangerouslySetInnerHTML={desc} />
        }
        <Videos videos={page.videos} play_video_album={@props.play_video_album} />

        {
          if page.uis?
            <div className='uis'>
              <a href='#' className='ui button green large'>
                <i className='icon browser' /> 显示界面示意图
              </a>
            </div>
        }
        {
          if page.pc_demo
            <div className='pc-demo'>
              <a href='/views/case' target='_blank' className='ui button green large'>
                <i className='icon desktop' /> 访问 PC 演示
              </a>
            </div>
        }
        {
          if page.mobile_demo
            <div className='mobile-demo'>
              <div className='tip'>
                <i className='icon qrcode' /> 扫码访问手机演示
              </div>
              <div className='qr'>
                <img src='http://i.teamkn.com/i/TF4iJEUp.jpg?qrcode|imageMogr2/crop/!248x248a24a24' />
              </div>
            </div>
        }
      </div>
    </div>


Videos = React.createClass
  render: ->
    if @props.videos?
      <div className='videos'>
      {
        for album, idx in @props.videos
          <div key={idx} className='video-card' onClick={@play(album)}>
            <div className='cover' style={backgroundImage: "url(#{album.cover || ''})"}>
              <i className='icon video play outline' />
            </div>
            <div className='video-ct'>
              <div className='name'>{album.name}</div>
              <div className='ui button basic green mini'>播放视频</div>
            </div>
          </div>
      }
      </div>
    else
      <div />

  play: (album)->
    =>
      @props.play_video_album album

VideoLayer = React.createClass
  getInitialState: ->
    album: null
    open: false
    current_idx: null

  render: ->
    if @state.open
      src = @state.album.mp4s[@state.current_idx].url

      <div className='video-layer'>
        <VideoPlayer key={@state.current_idx} src={src} />
        <div className='video-list'>
          {
            for mp4, idx in @state.album.mp4s
              klass = new ClassName
                'item': true
                'active': idx == @state.current_idx

              <a className={klass} key={idx} href='javascript:;' onClick={@toggle(idx)}>{mp4.name}</a>
          }
          <a className='close' href='javascript:;' onClick={@close}><i className='icon power' /> 关闭</a>
        </div>
      </div>
    else
      <div />

  close: ->
    @setState open: false

  open: (album)->
    @setState
      open: true
      album: album
      current_idx: 0

  toggle: (idx)->
    =>
      return if idx == @state.current_idx
      @setState
        current_idx: idx


ref_animate = (ref, animate_css_name)->
    $dom = jQuery ReactDOM.findDOMNode ref
    $dom.removeClass animate_css_name
    setTimeout ->
      $dom.addClass animate_css_name
    , 0