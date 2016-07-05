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

      <RightPart page={page} ref='rpart' />

      <div className='bottom'>
        <a className='ui button'>前翻</a>
        <a className='ui button'>后翻</a>
      </div>

      <VideoLayer />
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

    desc = 
      __html: marked(page.desc || '')

    <div className='right-part'>
      <h2 className='title'>{page.subname || page.name}</h2>
      <div className='detail'>
        <div className='desc' dangerouslySetInnerHTML={desc} />
        <Videos videos={page.videos} />

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
              <div className='ui button basic green small'>播放视频</div>
            </div>
          </div>
      }
      </div>
    else
      <div />

  play: (album)->
    =>
      console.log album.mp4s

VideoLayer = React.createClass
  render: ->
    <div className='video-layer'>
      <VideoPlayer src='http://pimfans.oss-cn-beijing.aliyuncs.com/%E9%93%B6%E8%A1%8C%E7%A7%91%E6%8A%80%E4%B8%AD%E5%BF%83%E5%9F%B9%E8%AE%AD%E5%B9%B3%E5%8F%B0/%E7%90%86%E8%B4%A2%E7%BB%8F%E7%90%86%E5%9F%B9%E8%AE%AD/01-%E5%BB%BA%E7%AB%8B%E6%B5%85%E5%B1%82%E7%9A%84%E6%A6%82%E5%BF%B5%E4%BD%93%E7%B3%BB-720p.mp4' />
      <div className='video-list'>
        <a className='item' href='javascript:;'>1. blahblah</a>
        <a className='item' href='javascript:;'>2. blahblah</a>
        <a className='item' href='javascript:;'>3. blahblah</a>
        <a className='item' href='javascript:;'>4. blahblah</a>
      </div>
    </div>

ref_animate = (ref, animate_css_name)->
    $dom = jQuery ReactDOM.findDOMNode ref
    $dom.removeClass animate_css_name
    setTimeout ->
      $dom.addClass animate_css_name
    , 0