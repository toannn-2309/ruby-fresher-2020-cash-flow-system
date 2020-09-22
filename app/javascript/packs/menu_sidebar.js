$(window).on('turbolinks:load', function() {
  $(document).ready(function(){
    const currentLocation = location.href;
    const menuItem = document.querySelectorAll('.menu-item > a')
    const pathBreadcrumb = document.querySelector('ol li:nth-child(2) > a')
    const menuLenght = menuItem.length
    for (let i = 0; i < menuLenght; i++) {
      if (menuItem[i].href == currentLocation)  {
        menuItem[i].className = 'nav-link active'
      }
    }
    if (pathBreadcrumb != null) {
      for (let i = 0; i < menuLenght; i++) {
        if (menuItem[i].href ==  pathBreadcrumb.href){
          menuItem[i].className = 'nav-link active'
        }
      }
    }
  });
});
