$(function() {
  var swiper = new Swiper('.image-carousel', {
    slidesPerView: 2,
    spaceBetween: 30,
    autoHeight: false,
    pagination: {
      el: '.swiper-pagination',
      clickable: true,
    },
    breakpoints: {
      0: {
        slidesPerView: 1,
        spaceBetween: 40,
      },
      991: {
        slidesPerView: 2,
        spaceBetween: 50,
      },
    }
  });
});
