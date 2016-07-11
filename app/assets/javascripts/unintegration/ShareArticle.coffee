@ShareArticle = React.createClass
  render: ->
    <div className="share-article">
      <div className="head">
        分享文章
      </div>
      <div className="user-card">
        <div className="avatar">
          <img src="http://i.teamkn.com/i/kHF4R2Cx.jpg" />
        </div>
        <div className="name">宋亮</div>
        <div className="post">
          <span>职务：</span>
          <span>销售经理</span>
        </div>
        <div className="phone">
          <span>电话：</span>
          <span>110-1110-1111</span>
        </div>
        <div className="desc">
          竭诚为您服务
        </div>
      </div>

      <div className="share-url">
        <div>分享链接：</div>
        <div className="ui info message">
        {"http://#{document.location.hostname}/share/1/views/read#"}
        </div>
      </div>

      <div className="ui warning message">
      文章已经增加到你的个人文章中心，你可以通过复制上面的链接来进行分享
      </div>
    </div>
