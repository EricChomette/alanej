const barCirlce = () => {

if(document.querySelector(".circular-progress")){
  
let progressBars = document.querySelectorAll(".circular-progress");
let valueContainers = document.querySelector(".value-container span");
let i = 1;
var y = window.scrollY;

function loadStart(){
progressBars.forEach((progressBar) => {
  console.log(scrollY);

let valueContainer = document.querySelector(`#RatingNum${i}`);



let colorPick = "a";

let progressValue = 0;
let stocker = valueContainer.innerHTML;
let progressEndValue = (stocker*2) * 10;
let textEndValue = stocker
let speed = 20;

function colorset(value){

if (value >= 0 && value < 20){
  colorPick = '#ff0000';
  return colorPick
}
if (value >= 20 && value < 50){
  colorPick = '#ff8335';
  return colorPick
}
if (value >= 50 && value < 75){
  colorPick = '#daffb0';
  return colorPick
}
if (value >= 75 && value < 100){
  colorPick = '#5eff5e';
  return colorPick
}

}
let progress = setInterval(() => {
  progressValue++;

  progressBar.style.background = `conic-gradient( ${colorset(progressValue)} ${progressValue * 3.6}deg, #cadcff  ${progressValue * 3.6}deg)`;

  
  if(progressValue >= progressEndValue){
    clearInterval(progress);
  }
},speed);
i++;

});
}
window.addEventListener('scroll', () => {
  if (window.scrollY >180) {
    loadStart();
  }

});
if (window.scrollY >180) {
  loadStart();
}

}
}
export {barCirlce};