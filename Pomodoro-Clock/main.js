$(document).ready(function() {
    var MAX_NUM = 999;
    var isPlaying = false;
    var isPaused = false;
    var onSession = true;
    var seconds = 0;
    var three_quarters = 0;
    var half = 0;
    var one_quarter = 0;
    var countdown = 0;
    // Attach on click functions

    function changeTime(num, inc) {
        var text = num.text();
        if(inc) {
            if(text < MAX_NUM)
                num.text(parseInt(text) + 1);
        }
        else {
            if(text > 1)
                num.text(parseInt(text) - 1);
        }
    }

    function getSeconds() {
        return parseInt(onSession ? $(".container > .session > .number").text() : $(".container > .break > .number").text()) * 60;
    }


    function parseSeconds() {
        var min = Math.floor(seconds / 60);
        if(min === 0)
            min = "00";
        else if(min < 10)
            min = "0" + min;
        var sec = seconds % 60;
        if(sec === 0)
            sec = "00";
        else if(sec < 10)
            sec = "0" + sec;
        return min + ":" + sec;
    }

    function begin() {
        if(!isPaused) {
            seconds = getSeconds();
            three_quarters = seconds * 0.75;
            half = seconds * 0.5;
            one_quarter = seconds * 0.25;
            isPaused = false;
        }
        isPlaying = true;

        $(".current-time").text(parseSeconds(seconds));

        countdown = setInterval(function() {
            seconds--;

            $(".current-time").text(parseSeconds());
            if(seconds > three_quarters) {
                $(".current-time").css({"color": "black"});
            }
            else if(seconds <= three_quarters && seconds > half) {
                $(".current-time").css({"color": "orange"});
            }
            else if(seconds <= half && seconds > one_quarter) {
                $(".current-time").css({"color": "darkorange"});
            }
            else if(seconds <= one_quarter) {
                $(".current-time").css({"color": "red"});
            }


            if(seconds <= 0) {
                $(".current").text(
                    onSession ? "Break" : "Session"
                );
                onSession = !onSession;
                seconds = getSeconds();
                three_quarters = seconds * 0.75;
                half = seconds * 0.5;
                one_quarter = seconds * 0.25;
            }
        }, 1000);
    }

    $(".increment").on("click", function() {
        var num = $(this).parent().find(".number");
        changeTime(num, true);
    });

    $(".decrement").on("click", function() {
        var num = $(this).parent().find(".number");
        changeTime(num, false);
    });

    $(".start").on("click", function() {
        if(!isPlaying) {
            begin();
        }
    });

    $(".pause").on("click", function() {
        if(isPlaying) {
            clearInterval(countdown);
            isPlaying = false;
            isPaused = true;
        }
    });

    $(".stop").on("click", function() {
       if(isPlaying) {
           clearInterval(countdown);
           seconds = 0;
           onSession = true;
           isPlaying = false;
           isPaused = false;

           $(".current-time").text(parseSeconds(seconds));
       }
    });

    $(".restart").on("click", function() {
        clearInterval(countdown);
        isPaused = false;
        isPlaying = false;
        seconds = 0;
        begin();
    });
});