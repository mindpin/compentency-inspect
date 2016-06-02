@AdminQuestionsPage = React.createClass
  render: ->
    <div className='admin-questions-page'>
      <div>
        <a className='ui button green' href={@props.data.new_question_url}>新增题目</a>
      </div>
      <AdminQuestionsPage.Table data={@props.data} />
    </div>

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            kind: "题目类型"
            content: "题目内容"
            answer: "参考答案"
            actions: '操作'
          data_set: @props.data.questions.map (x)->
            {
              id: x.id
              kind: x.kind
              content: x.content
              answer:
                switch x.kind
                  when "single_choice", "multi_choice"
                    for choice, i in x.admin_answer["choices"]
                      <div>
                        <i className="icon #{if choice['id'] == x.admin_answer['correct'] then 'checkmark green' else 'remove red'}"></i>
                        {choice["text"]}
                      </div>
                  when "bool"
                    if x.admin_answer
                      <i className="icon checkmark green"></i>
                    else
                      <i className="icon remove red"></i>
                  else
                    x.admin_answer

              actions:
                <a className='ui button mini green' href={x.admin_edit_url}>
                  <i className='ui edit' /> 修改
                </a>
            }

          th_classes: {}
          td_classes: {
          }

          paginate: @props.data.paginate
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='知识点' />
        </div>


