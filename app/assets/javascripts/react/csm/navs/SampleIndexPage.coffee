@SampleIndexPage = React.createClass
  render: ->
    <div className='sample-index-page'>
      <div className='header-image'>
        <div>我是顶图</div>
        <a href='/outline' className='ui button basic blue'>enter</a>
      </div>
      <div className='features'>
        <div className='feature'>
          知识库 - 平台能够用于构建知识库
        </div>
        <div className='feature'>
          培训 - 可以通过平台开展培训
        </div>
        <div className='feature'>
          移动内容呈现 - 针对智能手机呈现内容
        </div>
      </div>
    </div>


Old = React.createClass
  render: ->
    <ul>
      <li><a href='/views/read'>五种视图</a></li>
      <li><a href='/parser/ques-yaml'>QUES YAML Parser</a></li>
    </ul>