var ItemComment = React.createClass({

  getInitialState() {
    var isUpVote = this.checkIsUpVote(this.props.comment.actions);

    return {
      styleFrEdit: {display: "none"},
      styleFrShow: {display: "flex"},
      content: this.props.comment.content,
      up_vote: this.props.comment.up_vote,
      isUpVote: isUpVote
    };
  },

  checkIsUpVote(actions) {
    var isUpVote = false;
    if (gon.current_user != null) {
      _.each(actions, function(action, key) {
        if (action.user_id == gon.current_user.id
          && action.type_act == "up_vote") {
          isUpVote = true;
        }
      });
    }

    return isUpVote;
  },

  componentDidMount() {
    $(this.refs.formEditComment).submit(function(e){
      e.preventDefault();
    })
  },

  componentWillReceiveProps(nextProps) {
    this.setState({comment: nextProps.comment,
      content: nextProps.comment.content});
  },

  handleEdit(e) {
    this.state.styleFrEdit = {display: "block"};
    this.state.styleFrShow = {display: "none"};
    this.forceUpdate();
  },

  handleSave(e) {
    var self = this;
    var formdata = new FormData(this.refs.formEditComment);

    $.ajax({
      url: '/comments/' + this.props.comment.id,
      method: 'POST',
      processData: false,
      contentType: false,
      data: formdata
    }).done(function(result) {
      if (result.status == 1) {
        $(self.refs.formEditComment).find('textarea[name="content"]').val("");
        self.setState({
          styleFrEdit: {display: "none"},
          styleFrShow: {display: "flex"}
        });
      }
    });
  },

  handleCancel(e) {
    this.setState({
      styleFrEdit: {display: "none"},
      styleFrShow: {display: "flex"},
      content: this.props.comment.content
    });
  },

  handleDelete(e) {
    var self = this;
    var r = confirm(I18n.t("question_page.confirm_delete"));

    var fd = new FormData();
    fd.append( '_method', 'DELETE');

    if (r == true) {
      $.ajax({
        url: '/comments/' + this.props.comment.id,
        method: 'POST',
        processData: false,
        contentType: false,
        data: fd
      }).done(function(result) {
        if (result.status == 1) {
          self.props.removeComment(self.props.comment.id);
        }
      });
    }
  },

  handleChangeEdit(e) {
    this.setState({content: e.target.value});
  },

  upVote() {
    var self = this;
    var fd = new FormData();

    $.ajax({
      url: '/comments/' + this.props.comment.id + '/votes/1',
      method: 'POST',
      data: {_method: "PUT"}
    }).done(function(result) {
      if (result.status == 1) {
        self.setState({up_vote: self.state.up_vote + 1, isUpVote: true})
      }
    });
  },

  removeVote() {
    var self = this;

    $.ajax({
      url: '/comments/' + this.props.comment.id + '/votes/0',
      method: 'POST',
      data: {_method: "PUT"}
    }).done(function(result) {
      if (result.status == 1) {
        self.setState({up_vote: self.state.up_vote - 1, isUpVote: false})
      }
    });
  },

  render: function() {
    var rows = [];
    var classVoteUp = classNames({ hidden: this.state.isUpVote });
    var classDontVote = classNames({ hidden: !this.state.isUpVote });

    return (
      <div className="item-comment">
        <div className="wr-fr-edit" style={this.state.styleFrEdit}>
          <form className="fr-edit" ref="formEditComment">
            <input type="hidden" name="_method" value="PUT" />
            <div className="form-group">
              <textarea className="form-control content-edit"
                name="content"
                defaultValue={this.state.content}
                value={this.state.content}
                onChange={this.handleChangeEdit}>
              </textarea>
            </div>

            <div className="action">
              <button className="btn-save-edit btn btn-primary"
                onClick={this.handleSave}>{I18n.t("question_page.save")}
              </button>
              <button className="btn-save-cancel btn btn-default"
                onClick={this.handleCancel}>{I18n.t("question_page.cancel")}
              </button>
            </div>
          </form>
        </div>
        <div className="wr-fr-show" style={this.state.styleFrShow}>
          <div className="vt-count-vote">
            <a href="javascript:" className="short-link">
              {this.state.up_vote}
            </a>
          </div>
          <div className="vt-action-vote">
            <a href="javascript:"
              className={classVoteUp}
              onClick={this.upVote}>
              <i className="fa fa-thumbs-o-up" aria-hidden="true"></i>
            </a>
            <a href="javascript:"
              className={classDontVote}
              onClick={this.removeVote}>
              <i className="fa fa-thumbs-up" aria-hidden="true"></i>
            </a>
          </div>

          <div className="vt-comment" style={this.state.styleFrShow}>
            <p>
              {this.state.content}
              <a href="javascript:" title={this.props.comment.user.name}>
                {this.props.comment.user.name}
              </a>
              <time>{this.props.comment.created_at}</time>
              {gon.current_user
                && this.props.comment.user.id
                == gon.current_user.id && (
                <span className="wr-act">
                  <a className="edit-com" onClick={this.handleEdit}>
                    <i className="fa fa-pencil-square-o" aria-hidden="true"></i>
                  </a>
                  <a className="delete-com"
                    onClick={this.handleDelete}>
                    <i className="fa fa-times" aria-hidden="true"></i>
                  </a>
                </span>
              )}
            </p>
          </div>
        </div>
      </div>
    );
  }

});
