var VoteQuestion = React.createClass({
  getInitialState() {
      return {
        question: this.props.question,
        act: 0
      };
  },

  componentDidMount() {
  },

  componentWillReceiveProps(nextProps) {
  },

  handleUp() {
    var self = this;
    $.ajax({
      url: '/questions/' + self.state.question.id,
      method: 'POST',
      dataType: "json",
      data: {_method: "PUT", act: 1}
    }).done(function(result) {
        if (result.status == 1) {
          self.setState({act: 1, question: Object.assign({},
            self.state.question, result.data)});
          self.forceUpdate();
        }
    });
  },

  handleDown() {
    var self = this;
    $.ajax({
      url: '/questions/' + self.state.question.id,
      method: 'POST',
      dataType: "json",
      data: {_method: "PUT", act: 0}
    }).done(function(result) {
        if (result.status == 1) {
          self.setState({act: -1, question: Object.assign({},
            self.state.question, result.data)});
          self.forceUpdate();
        }
    });
  },

  render() {
    return (
      <div className="wr-vote">
        <a href="javascript:" onClick={this.handleUp} className="icon-up">
          <i className="fa fa-sort-asc" aria-hidden="true"></i>
        </a>
        <span className="number-sum">
          {this.state.question.up_vote - this.state.question.down_vote}
        </span>
        <a href="javascript:" onClick={this.handleDown}
          className="icon-down">
            <i className="fa fa-sort-desc" aria-hidden="true"></i>
        </a>
      </div>
    );
  }

});
