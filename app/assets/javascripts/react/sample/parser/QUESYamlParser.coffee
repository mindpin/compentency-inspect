@QUESYamlParser = React.createClass
  getInitialState: ->
    data: [
      {
        object_name: '客户'
        facts: [
          {
            fact_name: '家庭状况'
            facts: [
              {
                fact_name: '子女状况'
                tags: [
                  {tag_name: '无子女'}
                  {tag_name: '单子女'}
                  {tag_name: '双胞胎'}
                  {tag_name: '多子女'}
                ]
              }
              {
                fact_name: '婚姻状况'
              }
            ]
          }
          {
            fact_name: '健康状况'
          }
          {
            fact_name: '年龄'
          }
          {
            fact_name: '财务状况'
          }
        ]
      }
    ]

  render: ->
    json = JSON.stringify @state.data

    <div>
      <textarea value={json} onChange={@change} />
      <Parser />
    </div>

  change: ->


Parser = React.createClass
  render: ->
    <div></div>