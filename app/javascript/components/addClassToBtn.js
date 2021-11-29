const loading= () =>{
  if (document.querySelector("#goAnim")) {
    const div = document.querySelector(".home-container");
    const div2 = document.querySelector(".load-container");
    const btn = document.querySelector("#goAnim");
    const txt = document.querySelector(".load-text");
      btn.addEventListener("click", function(){
        div.classList.add("elementToFadeIn");
        div2.classList.add("elementToFadeOut");
        txt.classList.add("clignote");
        var titles = [
         "Recherche itinéraire...",
         "Recupération des données méteo",
         "Recherche de puff...",
         "Selection des stations..."
      ];
function newTitle () {
    var i = (Math.random() * titles.length) | 0;
    txt.innerText = titles[i];
}

newTitle();   
      setInterval(function(){ 
        //code goes here that will be run every 5 seconds.
        newTitle(); 
    }, 4000);
    });
    
  }
}
export {loading};