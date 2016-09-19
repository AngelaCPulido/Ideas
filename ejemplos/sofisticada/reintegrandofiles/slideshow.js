var currentSlide = "#slide-1";
var currentPosition = 0;
var navWidth = 600;
var slideWidth = 97;

function hideCaption (caption)
{
  caption.fadeOut();
}

function showCaption (caption)
{
  caption.fadeIn();
}

function displaySlide (slide)
{
  $('#slideshow-wrap '+currentSlide).fadeOut('slow');
  $('#slideshow-wrap '+slide).fadeIn('slow');
  currentSlide = slide;
}

function clearSelected ()
{
  $('#slideshow-nav').find('li').each(function(){
    $(this).removeClass("selected");
  });
}

function updateNav(shiftValue)
{
  var shiftLeft = shiftValue * slideWidth;

  if (shiftLeft + currentPosition >= 0)
  {
    $('#slideshow .left-arrow').css('visibility', 'hidden');
  }

  currentPosition = shiftLeft + currentPosition;

  $('#slideshow-nav').css('left', currentPosition);

  if (currentPosition < 0)
  {
    $('#slideshow .left-arrow').css('visibility', 'visible');
  }

  if ((currentPosition * -1 + slideWidth * 6) < navWidth)
  {
    $('#slideshow .right-arrow').css('visibility', 'visible');
  }
  else
  {
    $('#slideshow .right-arrow').css('visibility', 'hidden');
  }

}

$(document).ready(function() {
  if ($('#slideshow-wrap li').length > 0)
  {

    navWidth = 0;
    $('#slideshow-nav').find('li').each(function() {
      navWidth += slideWidth;
    });

    $('#slideshow-nav').css('width', navWidth+'px');


    $('#slideshow-nav').find('li').each(function(){
      $(this).bind('click', function ()
      {
        var slide = $(this).find('a').attr('data-slide');

        if (slide != currentSlide)
        {
          clearSelected();
          displaySlide(slide);
          $(this).addClass("selected");
        }
      });
    });

    $('.slide-image').each(function() {

      hideCaption($(this).find('.caption'));
  
      $(this).bind('mouseenter', function(){
        showCaption($(this).find('.caption'));
      });

      $(this).bind('mouseleave', function(){
        hideCaption($(this).find('.caption'));
      });

      if($(this).attr('id') != 'slide-1')
      {
        $(this).css('display', 'none');
      }

    });

    if ($('#slideshow-nav li').length > 6)
    {

      $('#slideshow .left-arrow')
      .css('visibility', 'hidden')
      .bind('click',function(){
        updateNav(6);
      });

      $('#slideshow .right-arrow')
      .bind('click',function(){
        updateNav(-6);
      });
    }

  }
});