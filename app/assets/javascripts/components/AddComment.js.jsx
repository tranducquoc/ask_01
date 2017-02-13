var AddComment = React.createClass({

  getInitialState() {
    return {
      isShow: false,
      errors: (<span></span>)
    }
  },

  extractErrors(errors) {
    var rows = [];
    $.each(errors.content, function(k, value) {
      rows.push((<span className="error" key={k}>{value}</span>));
    });
    return rows;
  },

  componentDidMount() {
    var $formAdd = $(ReactDOM.findDOMNode(this.refs.formAddComment));
    var $btnAdd = $(ReactDOM.findDOMNode(this.refs.btnAdd));
    var $addComment = $(ReactDOM.findDOMNode(this.refs.addComment));
    var self = this;

    $addComment.click(function() {
      if (gon.current_user) {
        self.setState({isShow: true});
      } else {
        $(this).attr('href', gon.new_user_session_path);
      }
    });

    $formAdd.submit(function(e){
      e.preventDefault();
    });

    $btnAdd.click(function() {
      var formdata = new FormData($formAdd[0]);

      $.ajax({
        url: self.props.comments_path,
        method: 'POST',
        processData: false,
        contentType: false,
        data: formdata
      }).done(function(result) {
        if (result.status == 1) {
          self.props.addCommentToList(result.data);
          $formAdd.find('textarea[name="content"]').val("");
          self.setState({errors: (<span></span>)});
        } else {
          self.setState({errors: self.extractErrors(result.errors)});
        }
      });
    });
  },

  render() {
    var style = this.state.isShow ? {display: "block"} : {display: "none"};
    return (
      <div className="frame-add-comment">
        <a href="javascript:" className="act-add-comment" ref="addComment">
          {I18n.t("question_page.add_comment")}</a>
        <form action={this.props.comments_path} className="form-add-comment"
          method="post" ref="formAddComment" style={style}>
          <table className="ta-add-comment ta-fix" cellPadding="0"
            cellSpacing="0" width="100%">
            <tbody>
              <tr>
                <td>
                  <textarea className="form-control" name="content"></textarea>
                  <input type="hidden" value={this.props.commentable_type}
                    name="commentable_type" />
                  <input type="hidden" value={this.props.commentable_id}
                    name="commentable_id" />
                  <div className="errors">
                    {this.state.errors}
                  </div>
                </td>
                <td>
                  <button type="submit" className="btn btn-primary btn-add"
                    ref="btnAdd">{I18n.t("question_page.add_comment")}</button>
                </td>
              </tr>
            </tbody>
          </table>
        </form>
      </div>
    );
  }
});
