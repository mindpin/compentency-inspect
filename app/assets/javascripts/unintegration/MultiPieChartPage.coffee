@MultiPieChartPage = React.createClass
  render: ->
    <div className="multi-pie-chart-page">
      <div className="head">
        <div className="title">经验特征统计</div>
      </div>
      <div className="content">
        <MultiPieChart data={@props.data} />
      </div>
    </div>
