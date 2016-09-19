var currentPage = 1;
var numberOfPages = 1;

function changeArticlePage (increment)
{
    currentPage += increment;

    if(currentPage < 0)
    {
        currentPage = 1;
    }
    else if(currentPage > numberOfPages)
    {
        currentPage = numberOfPages;
    }

    displayArticlePage(currentPage);

}

function displayArticlePage (newPage)
{
    currentPage = newPage;
    var navWidth = 160 + (20 * parseInt(currentPage));
    var hide = 0;

    $('page').each(function ()
    {
        if ($(this).data('page') == currentPage)
        {
            $(this).css('display', 'block');
        }
        else
        {
            $(this).css('display', 'none');
        }
    });

    $('li.pager').removeClass("active");

    $('li.pager[value='+currentPage+']').addClass('active');

    if (currentPage == 1)
    {
        $('.left-arrow').css('display', 'none');
        hide = 1;
    }
    else if (currentPage > 1)
    {
        $('.left-arrow').css('display', 'block');
    }

    if(currentPage >= numberOfPages)
    {
        $('.right-arrow').css('display', 'none');
        hide = 1;
    }
    else
    {
        $('.right-arrow').css('display', 'block');
    }

    if (hide)
    {
        navWidth = 100 + (20 * parseInt(currentPage));
    }


    $('.nav-wrapper').css('width', navWidth+'px');
}



function changePage (increment)
{
    currentPage += increment;

    if(currentPage < 0)
    {
        currentPage = 1;
    }
    else if(currentPage > numberOfPages)
    {
        currentPage = numberOfPages;
    }

    displayPage(currentPage);

}

function displayPage (newPage)
{
    currentPage = newPage;
    var navWidth = 160 + (20 * parseInt(currentPage));
    var hide = 0;

    $('#promosub a').each(function ()
    {
        if ($(this).data('page') == currentPage)
        {
            $(this).css('display', 'block');
        }
        else
        {
            $(this).css('display', 'none');
        }
    });

    $('li.pager').removeClass("active");

    $('li.pager[value='+currentPage+']').addClass('active');

    if (currentPage == 1)
    {
        $('.left-arrow').css('display', 'none');
        hide = 1;
    }
    else if (currentPage > 1)
    {
        $('.left-arrow').css('display', 'block');
    }

    if(currentPage >= numberOfPages)
    {
        $('.right-arrow').css('display', 'none');
        hide = 1;
    }
    else
    {
        $('.right-arrow').css('display', 'block');
    }

    if (hide)
    {
        navWidth = 80 + (20 * parseInt(currentPage));
    }


    $('.nav-wrapper').css('width', navWidth+'px');
}

function smoothScroller(o) {

    posX = 0;
    leftDown = false;
    rightDown = false;
    vel = 0;
    acc = 1;
    maxSpeed = 5;
    totalWidth = 0;

    $(o).find('li').each(function() {
        totalWidth += $(this).outerWidth(true);
    });

    $(o).css({
        'width': totalWidth
    });


    $('.left-arrow').mousedown(function() {
        leftDown = true;
        $('.right-arrow').css({
            'visibility': 'visible'
        });
    });

    $('.right-arrow').mousedown(function() {
        rightDown = true;
        $('.left-arrow').css({
            'visibility': 'visible'
        });
    });

    $('*').mouseup(function() {
        rightDown = false;
        leftDown = false;
    });

    setInterval(updateListPos, 20);

    function updateListPos() {
        if(rightDown) {
            if(vel > maxSpeed * -1){
                vel -= acc;
            }
        }
        if(leftDown) {
            if(vel < maxSpeed){
                vel += acc;
            }
        }

        posX += vel;

        vel *= 0.9;

        if(maxSpeed * -1 < vel < maxSpeed) {
            posX += vel;
        }

        if(posX < totalWidth * -1 + $(o).parent().width()) {
            posX = totalWidth * -1 + $(o).parent().width();
            $('.right-arrow').css({
                'visibility': 'hidden'
            });
        }
        if(posX > 0) {
            posX = 0;
            $('.left-arrow').css({
                'visibility': 'hidden'
            });
        }

        $(o).css({
            'left': posX
        });
    }

}

function beginSearch ()
{
    var search = $('#nav input').val().trim();

    if (search.length > 0)
    {
        $('#nav input').val('');
        searchterms = search.split(" ");

        self.location= '/search?q='+searchterms.join("+");
    }
}

// Main Promotion Autoscrolling
$(document).ready(function() {

    $('#print a').bind('click', function () {
        window.print()
    });

    $('#nav').keyup(function (event) {
        
        if(event.keyCode == '13')
        {

            beginSearch();
        }
    });

    $('#nav .search .button01').bind('click', function(){
        beginSearch();
    });





    if ($('.faq').length > 0)
    {
        $('.faq').popupWindow({
            height:600,
            width:600,
            top:50,
            left:50,
            scrollbars:1
        });
    }

    if ($('page').length > 0)
    {
       $('#article').append('<div id="article-pages-nav" align="center" style="clear:left"><div class="nav-wrapper"><div class="left-arrow"></div><div class="counters"><ul></ul></div><div class="right-arrow"></div></div></div>');
       
        var counter = 0;


        $('page').each(function ()
        {
            counter++;
            $(this).data('page',counter);

                $('<li class="pager" value="'+counter+'">'+counter+'</li>').appendTo('.counters ul');

            if(counter > 1)
            {
                $(this).css('display', 'none');
            }
        });

        numberOfPages = counter;
       

        $('.left-arrow').click(function(){
            changeArticlePage(-1);
        });
        $('.right-arrow').click(function(){
            changeArticlePage(1);
        });

        $('li.pager').click(function(){
            displayArticlePage($(this).attr('value'));
        });

        displayArticlePage(1);
        
    }

    if ($('#section-pages-nav').length > 0)
    {
        var counter = 0;
        var pager = 1;

        $('#promosub a').each(function ()
        {
            $(this).data('page', pager);
            counter++;
            if (counter%12 == 0)
            {
                $('<li class="pager" value="'+pager+'">'+pager+'</li>').appendTo('.counters ul');
                pager++;
            }

            if(counter > 12)
            {
                $(this).css('display', 'none');
            }
        });

        numberOfPages = pager;
        $('<li class="pager" value="'+pager+'">'+pager+'</li>').appendTo('.counters ul');

        $('.left-arrow').click(function(){
            changePage(-1);
        });
        $('.right-arrow').click(function(){
            changePage(1);
        });

        $('li.pager').click(function(){
            displayPage($(this).attr('value'));

        });


        displayPage(1);

    }

    if ($('#mainpromowrap li').length > 0)
    {
        var AUTOSCROLL_INTERVAL = 8000 // milliseconds
	
        var promos = []
        var autoScrollPointer = 0

        var scrollToPromo = function(promo) {
            while(promo != promos[0]) {
                promos.push(promos.shift())
            }
            $('#mainpromowrap').animate({
                'left': -promo.target.position().left
            }, 150)
            $('#mainpromonav a.mainpromoactive').removeClass('mainpromoactive')
            promo.link.addClass('mainpromoactive')
        }
	
        var autoScroll = function() {
            if (autoScrollPointer > 0) {
                scrollToPromo(promos[1])
                autoScrollEnable()
            }
        }
	
        var autoScrollEnable = function() {
            clearTimeout(autoScrollPointer)
            autoScrollPointer = setTimeout(autoScroll, AUTOSCROLL_INTERVAL)
        }
	
        var autoScrollDisable = function() {
            clearTimeout(autoScrollPointer)
            autoScrollPointer = 0
        }
	
        $('#mainpromonav a')
        .each(function() {
            var target = $($(this).attr('data-promo'))
            var promo  = {
                target: target,
                link: $(this)
            };
            $(this).data('promo', promo)
            promos.push(promo)
        })
        .click(function(e) {
            e.preventDefault();
            var promo = $(this).data('promo')
            scrollToPromo(promo)
        })
		
        $('#mainpromoarea').hover(
            function() {
                autoScrollDisable()
            },
            function() {
                autoScrollEnable()
            })
	
        autoScrollEnable();
    
        // there are more than four items- implement additional behavior
    
        if ($('#promo-nav-wrapper').length > 0)
        {
            smoothScroller($('#mainpromonav'));
        }

    }
})
