@PageTestWares = React.createClass
  render: ->
    <div>
      {
        for test_ware in @props.data
          switch test_ware.kind
            when "single_choice"
              <SingleChoiceTestWare key={test_ware.id} data={test_ware} />
            when "multi_choice"
              <MultiChoiceTestWare key={test_ware.id} data={test_ware} />
            when "bool"
              <BoolTestWare key={test_ware.id} data={test_ware} />
            when "essay"
              <EssayTestWare key={test_ware.id} data={test_ware} />
            when "file_upload"
              <FileUploadTestWare key={test_ware.id} data={test_ware} />
      }
    </div>
