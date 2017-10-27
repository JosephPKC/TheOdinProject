$(document).ready(function() {
    //Default values
    const dim = 16;

    /* Make the initial grid */
    // prompt("initial");
    createGrid(dim);

    /* Make the controls */
    attachControls();

    /* Functions */
    function chooseRandomColorValue() {
        return Math.floor(Math.random() * 256);
    }

    function chooseRandomColor() {
        return "rgb(" + chooseRandomColorValue() +
            "," + chooseRandomColorValue() +
            "," + chooseRandomColorValue() +
            ")";
    }

    function createSquare(row, col) {
        // console.log(row, col);
        var square = $("<div>", {"class": "grid-square"});
        square.css({"grid-row-start": "\"" + row + "\"", "grid-column-start": "\"" + col + "\"",
            "grid-row-end": "span 1", "grid-column-end": "span 1"});
        // $(".grid").find(":last").after(square);
        $(".grid").append(square);
    }

    function createGrid(size) {
        var grid = $(".grid");
        grid.css({"grid-template-rows": "repeat(" + size + ", 1fr)",
                  "grid-template-columns": "repeat(" + size + ", 1fr)"});
        $("body > .control-bar").after(grid);
        for(var i = 1; i <= size; i++) {
            for(var j = 1; j <= size; j++) {
                createSquare(i, j);
            }
        }
        $(".grid-square").on("mouseenter", function() {
            // console.log("Hovering");
           $(this).css({"background-color": chooseRandomColor()});
        });
    }

    function clearGrid() {
        $(".grid-square").css({"background-color": "white"});
    }

    function attachControls() {
        $(".clear").on("click", function() {
            clearGrid();
        });

        $(".resize").on("click", function() {
            var size = parseInt(prompt("Enter the size (Default: 16)"));
            $(".grid-square").remove();
            createGrid(size);
        })
    }
});