const loading= () =>{
 if (document.querySelector("#goAnim")) {
  const div = document.querySelector(".home-container");
  const div2 = document.querySelector(".load-container");

  const btn = document.querySelector("#goAnim");
  
    btn.addEventListener("click", function(){
      div.classList.add("elementToFadeIn");
      div2.classList.add("elementToFadeOut");   
    });
  }
}
export {loading};