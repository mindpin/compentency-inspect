@OutlineContent = React.createClass
  render: ->
    <div className='outline-content'>
      <div className='image'>
        <img src='http://i.teamkn.com/i/pL2lvPTx.jpg' />
      </div>

      <div className='right'>
        <div className='desc'>
          我是说明<br/>
          我是说明<br/>
          我是说明<br/>
          我是说明<br/>
          我是说明<br/>
          我是说明<br/>
          我是说明<br/>
        </div>
        <a href='#' className='ui button basic green'>界面示意图</a>
        <a href='/views/case' target='_blank' className='ui button basic green'>DEMO</a>
        <div className='qrcode'>
          <img src='http://i.teamkn.com/i/TF4iJEUp.jpg?qrcode|imageMogr2/crop/!248x248a24a24' />
        </div>
      </div>

      <div className='bottom'>
        <a className='ui button'>前翻</a>
        <a className='ui button'>后翻</a>
      </div>
    </div>