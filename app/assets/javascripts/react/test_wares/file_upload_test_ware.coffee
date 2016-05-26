@FileUploadTestWare = React.createClass
  render: ->
    <div className="ui segments">
      <div className="ui segment">
        {@props.data.content}
      </div>
      <div className="ui segment">
        <FileUploadTestWare.Upload question_id={@props.data.id} file_entity_id={@props.data.answer?.file_entity_id} download_url={@props.data.answer?.download_url} />
      </div>
    </div>

  statics:
    Upload: React.createClass
      getInitialState: ->
        status: UploadStatus.READY
        percent: 0
        file_entity_id: @props.file_entity_id
        download_url:   @props.download_url

      render: ->
        h = 50
        w = 320

        browse_style =
          width: "#{w}px"
          height: "#{h}px"

        <div className='one-upload'>
          <div className='browse' style={browse_style}>
            <FileUploadTestWare.UploadProgress {...@state} />
            {
              title = @props.title || '把编写好的代码文件打包成压缩包上传'
              desc = @props.desc ||
                <div>
                  支持 ZIP/RAR/TAR/GZ/BZ2/7Z/XZ 格式，最大 3MB
                </div>

              <UploadWidget.BrowseButton ref='browse_btn' status={@state.status}>
                <div className='btn-text'>
                  <div className='header'>{title}</div>
                  <div className='desc'>{desc}</div>
                </div>
              </UploadWidget.BrowseButton>
            }
            <FileUploadTestWare.DownloadBar download_url={@state.download_url} />
          </div>
        </div>

      componentDidMount: ->
        # $browse_button = jQuery React.findDOMNode @refs.browse_btn
        $browse_button = jQuery ReactDOM.findDOMNode @refs.browse_btn
        new QiniuFilePartUploader
          debug:                true
          browse_button:        $browse_button
          dragdrop_area:        null
          file_progress_class:  UploadUtils.GenerateOneFileUploadProgress(@)
          max_file_size:        '3MB'
          mime_types :          [{ title: 'Archive files', extensions: 'zip,rar,tar,gz,bz2,7z,xz' }]

      on_upload_event: (evt, params...)->
        switch evt
          when 'start'
            qiniu_file = params[0]
            @set_preview_data_url qiniu_file

          when 'remote_done'
            qiniu_response_info = params[0]
            @set_preview_true_url qiniu_response_info

          when 'local_done'
            response_info = params[0]
            file_entity_id  = response_info.file_entity_id
            download_url    = response_info.download_url
            @setState
              download_url: download_url
              file_entity_id: file_entity_id

            jQuery.ajax
              url: "/test_wares/save_answer"
              type: "POST"
              data:
                id: @props.question_id
                answer: file_entity_id
              dataType: "json"
              success: (res) =>
                console.log res


      set_preview_data_url: (qiniu_file)->
        console.log "set_preview_data_url"
        console.log qiniu_file

      set_preview_true_url: (qiniu_response_info)->
        console.log "set_preview_true_url"
        console.log qiniu_response_info

    UploadProgress: React.createClass
      render: ->
        if @props.status != UploadStatus.READY
          bar_style =
            width: "#{100 - @props.percent}%"

          <div className='percent'>
            {
              if @props.status is UploadStatus.UPLOADING
                <div className='bar' style={bar_style} />
            }
            {
              switch @props.status
                when UploadStatus.UPLOADING
                  <div className='p'>{@props.percent}%</div>
                when UploadStatus.REMOTE_DONE
                  <div className='p'>
                    <div className='ui active inverted loader' />
                  </div>
                when UploadStatus.LOCAL_DONE
                  <div className='p'><i className='icon check circle' /></div>
            }
          </div>
        else
          <div />

    DownloadBar: React.createClass
      render: ->
        if @props.download_url
          <a href={@props.download_url}>下载已经上传的压缩包</a>
        else
          <a />
