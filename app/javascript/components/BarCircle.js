const barCirlce = () => {
if(document.querySelector(".circular-progress")){
let progressBars = document.querySelectorAll(".circular-progress");
let valueContainers = document.querySelectorAll(".value-container span");

progressBars.forEach((progressBar) => {
valueContainers.forEach((valueContainer) => {



let colorPick = "a";
console.log(progressBar,valueContainer);
let progressValue = 0;
const stocker = valueContainer.innerHTML;
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
});
});
}
}
export {barCirlce};