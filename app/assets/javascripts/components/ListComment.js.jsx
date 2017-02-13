var ListComment = React.createClass({
  getInitialState() {
    return {
      comments: this.props.comments
    }
  },

  componentDidMount() {

  },

  removeComment(id) {
    this.props.removeComment(id);
  },

  componentWillReceiveProps(nextProps) {
    this.setState({comments: nextProps.comments});
  },

  render: function() {
    var rows = [];
    var self = this;
    this.state.comments.forEach(function(comment, key) {
        rows.push(
          <ItemComment comment={comment} key={key}
            removeComment={self.removeComment}/>
        );
    });
    return (
      <div className="list-comments ta-fix">
        {rows}
      </div>
    );
  }
});
