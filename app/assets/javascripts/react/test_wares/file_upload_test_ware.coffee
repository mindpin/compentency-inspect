@FileUploadTestWare = React.createClass
  render: ->
    <div className='file-upload-ware'>
      <div>
        <strong>{@props.data.content}</strong>
      </div>
      <div className="ui segment">
        <FileUploadTestWare.Upload 
          question_id={@props.data.id} 
          file_entity_id={@props.data.answer?.file_entity_id} 
          download_url={@props.data.answer?.download_url} 
          on_answer_change={@props.on_answer_change}
        />
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
        <div className='one-upload'>
          <div className='browse'>
            {
              title = @props.title || '把编写好的代码文件打包成压缩包上传'
              desc = @props.desc ||
                <div>
                  支持 ZIP / RAR / TAR / GZ / BZ2 / 7Z / XZ 压缩格式，最大 3MB
                </div>
              <div className='desc ui message warning'>
                {title}<br/>
                {desc}
              </div>
            }
            <FileUploadTestWare.UploadProgress {...@state} />
            {
              <UploadWidget.BrowseButton ref='browse_btn' status={@state.status}>
                <a href='javascript:;' className='ui button green mini'>
                  <i className='icon upload' /> 上传文件
                </a>
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

            @props.on_answer_change(@props.question_id, file_entity_id)

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
        <div className='download' style={marginTop: '1rem'}>
        {
          if @props.download_url
            <a className='download' href={@props.download_url}>
              <i className='icon attach' /> 下载已经上传的压缩包
            </a>
        }
        </div>
