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
    first_page = pages[0]
    last_page = pages[pages.length - 1]

    page_idx = pages.indexOf page

    <div className='outline-content'>
      <div className='left-part'>
        <div className='slide-outer'>
          <div className='slide' ref='slide'>
            <div className='slide-inner'>
              <img src={page.slide} />
            </div>
          </div>

          {
            prev_klass = new ClassName
              "prev": true
              "disabled": page == first_page

            next_klass = new ClassName
              "next": true
              "disabled": page == last_page

            <div className='page-turning'>
              <a className={prev_klass} href='javascript:;' onClick={@prev(page_idx)}>
                <i className='icon chevron left' /> 上一页
              </a>
              <a className={next_klass} href='javascript:;' onClick={@next(page_idx)}>
                下一页 <i className='icon chevron right' />
              </a>
            </div>
          }
        </div>
      </div>


      <div className='right-part' ref='rpart'>
        <h2 className='title'>{page.name}</h2>
        <div className='detail'>
          <div className='desc'>
            我是说明文字<br/>
            我是说明文字<br/>
            我是说明文字<br/>
            我是说明文字<br/>
            我是说明文字<br/>
            我是说明文字<br/>
            我是说明文字<br/>
          </div>
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

      <div className='bottom'>
        <a className='ui button'>前翻</a>
        <a className='ui button'>后翻</a>
      </div>
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
    jQuery ReactDOM.findDOMNode @refs.slide
      .stop()
      .css
        'margin-top': -50
        'opacity': 0.1
      .animate {
        'margin-top': 0
        'opacity': 1
      }, 500, 'linear'

    jQuery ReactDOM.findDOMNode @refs.rpart
      .stop()
      .css
        'margin-top': 50
        'opacity': 0.1
      .animate {
        'margin-top': 0
        'opacity': 1
      }, 500, 'linear'