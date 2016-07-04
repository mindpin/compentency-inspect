@OutlineContent = React.createClass
  getInitialState: ->
    pages = {}
    for item in @props.outline_data
      pages[item.id] = item
      for sitem in item.children || []
        pages[sitem.id] = sitem

    pages: pages

  render: ->
    cid = location.href.split('#')[1]
    if cid? and cid.length
      cid = cid
    else
      cid = '0'

    page = @state.pages[cid]

    <div className='outline-content'>
      <div className='left-part'>
        <div className='slide-outer'>
          <div className='slide'>
            <div className='slide-inner'>
              <img src={page.slide} />
            </div>
          </div>
        </div>
      </div>


      <div className='right-part'>
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

  componentDidMount: ->
    window.outline_content = @