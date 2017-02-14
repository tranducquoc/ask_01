var HomeListTopic = React.createClass({

  getInitialState() {
    var self = this;
    var topics = _.reject(this.props.topics, function(item){
      var alreadyVal = _.find(self.props.topicsFollow, function(val) {
        return val.id == item.id
      });
      return typeof alreadyVal != "undefined";
    });

    return {
      topicsFollow: this.props.topicsFollow,
      topics: topics,
      initialTopics: topics,
      isShowSuggest: false,
    }
  },

  componentDidMount() {

  },

  removeTopicFollow(topic) {
    this.state.topicsFollow = _.filter(this.state.topicsFollow, function(item){
      return item.id != topic.id;
    });
    this.state.topics.push(topic);
    this.forceUpdate();
  },

  addTopicFollow(topic) {
    this.state.topicsFollow.push(topic);
    this.state.topics = _.filter(this.state.topics, function(item){
      return item.id != topic.id;
    });
    this.forceUpdate();
  },

  handleChangeMode() {
    this.setState({isShowSuggest: !this.state.isShowSuggest});
  },

  handleChangeSearch(e) {
    this.state.topics = _.filter(this.state.initialTopics, function(item){
      return item.name.includes(e.target.value);
    });
    this.forceUpdate();
  },

  render() {
    var styleFrameSuggest = this.state.isShowSuggest ? {display: "block"} : {display: "none"};
    var text_action = this.state.isShowSuggest ? I18n.t("home_page.done") : I18n.t("home_page.edit");

    var rowTopicsFollow = [];
    var rowTopics = [];
    var self = this;

    this.state.topicsFollow.forEach(function(topic, key) {
      rowTopicsFollow.push(
        <ItemTopicFollow topic={topic} key={key} isShowRemove={self.state.isShowSuggest} removeTopicFollow={self.removeTopicFollow} />
      );
    });

    this.state.topics.forEach(function(topic, key) {
      rowTopics.push(
        <ItemTopic topic={topic} key={key} addTopicFollow={self.addTopicFollow}/>
      );
    });

    return (
      <div className="home-list-topic">
        <h3 className="title">
          <span className="title_with_link">{I18n.t("home_page.feed")}</span>
          <div className="hover-menu-chose" style={styleFrameSuggest}>
            <div className="hover-menu-content">
              <div className="selection_input_interaction">
                <input placeholder="Search topic to follow" name="search_topic" onChange={this.handleChangeSearch} />
              </div>
              <div className="container_topic_suggests">
                <ul className="sug_list_topic">
                  {rowTopics}
                </ul>
              </div>
            </div>
          </div>
          <div className="text-action" onClick={this.handleChangeMode}>{text_action}</div>
        </h3>
        <div className="paged-list-topic">
          <ul>
            {rowTopicsFollow}
          </ul>
        </div>
      </div>
    );
  }
});
