$(function() {
  $('a.forgot').click(function() {
    document.location = reset_password_path+'?email=' + $('#email').val()
  })
})