var ItemTopic = React.createClass({
  getInitialState() {
      return {
        topics: this.props.topics
      };
  },

  componentDidMount() {

  },

  componentWillReceiveProps(nextProps) {
    this.setState({topic: nextProps.topic});
  },

  addTopicFollow() {
    var self = this;
    $.ajax({
      url: '/topics/' + this.props.topic.id + '/fotopics',
      method: 'POST',
      data: {type: 1}
    }).done(function(result) {
      if (result.status == 1) {
        self.props.addTopicFollow(self.props.topic);
      }
    });
  },

  render() {
    return (
      <li className="item-list-choose">
        <a href="javascript:" onClick={this.addTopicFollow} className="act-add-topic">
          <i className="fa fa-plus-circle" aria-hidden="true"></i>
        </a>
        <span className="sug_topic_name">{this.props.topic.name}</span>
        <a href="javascript:" className="icon">
          <img src={this.props.topic.icon.url} className="img_25" />
        </a>
      </li>
    );
  }

});
