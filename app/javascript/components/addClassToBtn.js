var div = document.querySelector(".home-container");
var div2 = document.querySelector(".load-container");
//var div2 = document.querySelector(".fade2"); 
var btn = document.querySelector("#goAnim");

btn.addEventListener("click", function(){
  div.classList.add("elementToFadeIn");
  div2.classList.add("elementToFadeOut");
  // Wait until the animation is over and then remove the class, so that
  // the next click can re-add it.

});