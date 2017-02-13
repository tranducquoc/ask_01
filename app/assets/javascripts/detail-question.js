$(document).ready(function () {

  $("#form-add-comment").submit(function(e){
    e.preventDefault();
  });

  tinymce.init({
    selector: '.elem-answer-ques',
    height: 500,
    menubar: false,
    plugins: [
      'advlist autolink lists link image charmap print preview anchor',
      'searchreplace visualblocks code fullscreen',
      'insertdatetime media table contextmenu paste code'
    ],
    toolbar: 'undo redo | insert | styleselect | bold italic | \
      alignleft aligncenter alignright alignjustify | bullist \
      numlist outdent indent | link image',
    content_css: '//www.tinymce.com/css/codepen.min.css'
  });

  $('.submit-answer').click(function() {
    tinyMCE.triggerSave();
  });

});
