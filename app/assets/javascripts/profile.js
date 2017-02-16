$(document).ready(function() {
  $('#wr-profile').find('.action_follow').click(function() {
    var user_id = $(this).data('id');
    var action = $(this).data('action');
    var self = $(this);

    if (action == 'follow') {
      $.ajax({
        url: '/users/' + user_id + '/follows',
        method: 'POST',
        data: {type: 'follow'}
      }).done(function(result) {
        if (result.status == 1) {
          self.data('action', 'unfollow');
          self.text(self.data('unfollow'));
          var num = parseInt(self.next().text()) + 1;
          self.next().text(num);
        }
      });
    } else {
      $.ajax({
        url: '/users/' + user_id + '/follows',
        method: 'POST',
        data: {type: 'unfollow'}
      }).done(function(result) {
        if (result.status == 1) {
          self.data('action', 'follow');
          self.text(self.data('follow'));
          var num = parseInt(self.next().text()) - 1;
          self.next().text(num);
        }
      });
    }
  });
});
