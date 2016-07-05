@TargetView = React.createClass
  render: ->
    <div>
    {
      search_box_data =
        search_url: "/search_box_post_search"
        dashboard_url: "/user/dashboard"
        current_words: ["橘子", "苹果"]
        recommend_words: ["香蕉", "栗子", "火龙果"]
        results: [
          {title: "title1111", desc: "desc111"}
          {title: "title222", desc: "desc222"}
        ]

      <SearchBox data={search_box_data} />
    }
    </div>
