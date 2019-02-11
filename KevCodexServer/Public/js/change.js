var text = ["Software Developer", "Soccer Player", "Avid Hiker", "Casual Gamer", "Adventure Seeker", "Entrepreneur"];
var counter = 0;
var elem = document.getElementById("changeText");
var inst = setInterval(change, 1000);

function change() {
    elem.innerHTML = text[counter];
    counter++;
    if (counter >= text.length) {
        counter = 0;
    }
}