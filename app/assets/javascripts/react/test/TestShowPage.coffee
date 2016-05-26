@TestShowPage = React.createClass
  render: ->
    <div className='ui container'>
      <KcTest.Dispatcher {...@props.data} />
    </div>