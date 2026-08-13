(function ($) {
  'use strict';

  var ctx = window.TEMPLATES_FEED_CTX || '';
  var feedUrl = ctx + '/index/templates/feed';
  var lastSignature = '';
  var pollMs = 12000;

  function esc(text) {
    if (text == null) return '';
    var div = document.createElement('div');
    div.textContent = String(text);
    return div.innerHTML;
  }

  function quoteText(comment) {
    var c = (comment || '').trim();
    if (!c) return 'Shared a new rating.';
    return '\u201c' + c + '\u201d';
  }

  function starsHtml(rating) {
    var r = Math.max(0, Math.min(5, parseInt(rating, 10) || 0));
    var html = '';
    for (var i = 0; i < 5; i++) {
      html += i < r
        ? '<span class="text-warning">\u2605</span>'
        : '<span class="text-muted">\u2606</span>';
    }
    return html;
  }

  function destroyOwlCarousel($el) {
    if ($el.data('owl.carousel')) {
      $el.trigger('destroy.owl.carousel');
      $el.removeClass('owl-loaded owl-drag owl-grab');
      $el.find('.owl-stage-outer').children().unwrap();
      $el.children('.owl-nav, .owl-dots').remove();
    }
  }

  function initOwlCarousel($el) {
    $el.owlCarousel({
      center: true,
      loop: true,
      items: 1,
      margin: 30,
      stagePadding: 0,
      nav: false,
      navText: ['<span class="ion-ios-arrow-back">', '<span class="ion-ios-arrow-forward">'],
      responsive: {
        0: { items: 1 },
        600: { items: 3 },
        1000: { items: 3 }
      }
    });
  }

  function renderReviews(reviews) {
    var $carousel = $('.carousel-testimony');
    if (!$carousel.length) return;

    destroyOwlCarousel($carousel);

    if (!reviews || !reviews.length) {
      $carousel.html(
        '<div class="item"><div class="testimony-wrap p-4 pb-5 text-center">' +
        '<p class="mb-0">No reviews yet. Be the first to rate a salon!</p></div></div>'
      );
      initOwlCarousel($carousel);
      return;
    }

    var html = '';
    reviews.forEach(function (r) {
      var img = r.avatarUrl ? (ctx + r.avatarUrl) : (ctx + '/beauty/images/person_1.jpg');
      html +=
        '<div class="item">' +
        '<div class="testimony-wrap p-4 pb-5">' +
        '<div class="text">' +
        '<div class="line pl-5">' +
        '<p class="mb-2 pb-1">' + esc(quoteText(r.comment)) + '</p>' +
        '<p class="mb-4 small">' + starsHtml(r.rating) + '</p>' +
        '<span class="quote d-flex align-items-center justify-content-center">' +
        '<i class="icon-quote-left"></i></span></div>' +
        '<div class="d-flex align-items-center">' +
        '<div class="user-img" style="background-image: url(\'' + img.replace(/'/g, '') + '\')"></div>' +
        '<div class="ml-4">' +
        '<p class="name">' + esc(r.userName) + '</p>' +
        '<span class="position">' + esc(r.position) + '</span>' +
        (r.salonName ? '<br><small class="text-muted">' + esc(r.salonName) + '</small>' : '') +
        '</div></div></div></div></div>';
    });

    $carousel.html(html);
    initOwlCarousel($carousel);
  }

  function renderPosts(posts) {
    var $row = $('#recent-posts-row');
    if (!$row.length) return;

    if (!posts || !posts.length) {
      $row.html(
        '<div class="col-12 text-center text-muted py-5">' +
        'No posts yet. Community updates will appear here automatically.</div>'
      );
      return;
    }

    var html = '';
    posts.forEach(function (p) {
      var img = p.imageUrl && p.imageUrl.indexOf('http') === 0
        ? p.imageUrl
        : (p.imageUrl && p.imageUrl.indexOf('/') === 0 ? ctx + p.imageUrl : ctx + '/beauty/images/image_1.jpg');
      html +=
        '<div class="col-md-4 d-flex ftco-animate">' +
        '<div class="blog-entry justify-content-end">' +
        '<a href="#" class="block-20" style="background-image: url(\'' + img.replace(/'/g, '') + '\');"></a>' +
        '<div class="text p-4 float-right d-block">' +
        '<div class="d-flex align-items-center pt-2 mb-4">' +
        '<div class="one"><span class="day">' + esc(p.day) + '</span></div>' +
        '<div class="two"><span class="yr">' + esc(p.year) + '</span>' +
        '<span class="mos">' + esc(p.month) + '</span></div></div>' +
        '<h3 class="heading mt-2"><a href="#">' + esc(p.title) + '</a></h3>' +
        '<p>' + esc(p.excerpt) + '</p>' +
        '<p class="small text-muted mb-0">\u2014 ' + esc(p.authorName) + '</p>' +
        '</div></div></div>';
    });

    $row.html(html);
  }

  function applyFeed(data) {
    if (!data) return;
    if (data.signature && data.signature === lastSignature) return;
    lastSignature = data.signature || '';
    renderReviews(data.reviews);
    renderPosts(data.posts);
  }

  function fetchFeed() {
    return fetch(feedUrl, {
      headers: { Accept: 'application/json' },
      credentials: 'same-origin'
    })
      .then(function (res) {
        if (!res.ok) throw new Error('Feed request failed');
        return res.json();
      })
      .then(applyFeed)
      .catch(function (err) {
        console.warn('Templates feed:', err);
      });
  }

  $(function () {
    fetchFeed();
    setInterval(fetchFeed, pollMs);
  });
})(jQuery);
