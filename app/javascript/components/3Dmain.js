import * as THREE from 'three';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader.js';

const createBackground = () => {
const canva = document.getElementById("bg");
const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera( 30, window.innerWidth / window.innerHeight , 0.1,2000);
const loader = new GLTFLoader();
const sun_ico = document.getElementById("sun-ico");
const sunrise_ico = document.getElementById("sunrise-ico");
const sunset_ico = document.getElementById("sunset-ico");
const night_ico = document.getElementById("night-ico");
let modell = "Global Variable";
let today = new Date();
let time = today.getHours();
let  sun_ico_trigger =false;
let sunrise_ico_trigger = false;
let sunset_ico_trigger = false;
let night_ico_trigger = false;
console.log(time);
(function(){
  var script=document.createElement('script');
  script.onload=function(){
    var stats=new Stats();
    document.body.appendChild(stats.dom);
    requestAnimationFrame(function loop(){
      stats.update();requestAnimationFrame(loop)}
      );
    };script.src='//mrdoob.github.io/stats.js/build/stats.min.js';document.head.appendChild(script);})()




const renderer = new THREE.WebGLRenderer({
  canvas: document.querySelector('#bg'), antialias: true ,alpha: true

});


renderer.setSize(window.innerWidth, window.innerHeight - 7 );
renderer.outputEncoding = THREE.sRGBEncoding;
renderer.setClearColor( 0x000000, 0 );

camera.position.set( 50, -9, 20);


const object = []  ;
loader.load( 'SAPINS.glb', function ( gltf ) {
  gltf.scene.scale.set(6,6,6)
  gltf.scene.translateX(-150)
  gltf.scene.translateZ(-16)
  gltf.scene.translateY(-16)
  object.push(gltf.scene) ;
  let modell =  gltf.scene;

	scene.add( modell );

}, undefined, function ( error ) {

	console.error( error );

} );






const snows=[];
function addSnow(){
  const geometry = new THREE.SphereGeometry(0.10,10,10);
  const material = new THREE.MeshStandardMaterial({ color:0xffffff })
  const snow = new THREE.Mesh( geometry, material);
  const [x, y, z] = Array(3)
  .fill()
  .map(() => THREE.MathUtils.randFloatSpread(130));

snow.position.set(x, y, z);
snows.push(snow)
scene.add(snow);
}
function activebutton(){

}
function setnight(){
  canva.classList.remove("rise-set");
  canva.classList.add("night");
  const pointLight = new THREE.PointLight(0xbec2ff)
  pointLight.position.set(100,65,53)
  pointLight.intensity = -2;
  const ambientLight = new THREE.AmbientLight(0xbec2ff);
  scene.add(pointLight, ambientLight)
  Array(2000).fill().forEach(addSnow);
}
function setrise(){
  canva.classList.remove("day");
  canva.classList.remove("night");
canva.classList.add("rise-set");

const pointLight = new THREE.PointLight(0xff2d2d)
pointLight.position.set(-120,25,53)
pointLight.intensity = 1;

const ambientLight = new THREE.AmbientLight(0xff5d5d);
scene.add(pointLight, ambientLight)
Array(2000).fill().forEach(addSnow);
}

function setday(){
  canva.classList.remove("night");
  canva.classList.remove("rise-set");
  canva.classList.add("day");

  const pointLight = new THREE.PointLight(0xfffbcf);
  pointLight.position.set(120,45,53);
  pointLight.intensity = 1;

  const ambientLight = new THREE.AmbientLight(0xfffbcf);
  scene.add(pointLight, ambientLight);
}

function setset(){
  canva.classList.remove("night");
  canva.classList.remove("day");
  canva.classList.add("rise-set");

  const pointLight = new THREE.PointLight(0xff2d2d)
  pointLight.position.set(120,45,53)
  pointLight.intensity = 1;

  const ambientLight = new THREE.AmbientLight(0xff5d5d);
  scene.add(pointLight, ambientLight)
  Array(2000).fill().forEach(addSnow);
}

function Deftheme(){
  if(time >= 0 && time <= 6 ){
  setnight();

}
if(time > 6 &&  time < 9 ){
 setrise();
 sunrise_ico.classList.add("activeTime");
 sunset_ico.classList.remove("activeTime");
 sun_ico.classList.remove("activeTime");
 night_ico.classList.remove("activeTime");
}
if(time >= 9 && time < 17 )
{
 setday();
 sunrise_ico.classList.remove("activeTime");
 sunset_ico.classList.remove("activeTime");
 sun_ico.classList.add("activeTime");
 night_ico.classList.remove("activeTime");
  }
if (time >= 17 && time < 18 )
{
setset();
sunrise_ico.classList.remove("activeTime");
sunset_ico.classList.add("activeTime");
sun_ico.classList.remove("activeTime");
night_ico.classList.remove("activeTime");
}
if(time >= 18 ||  night_ico_trigger == true){
setnight();
sunrise_ico.classList.remove("activeTime");
sunset_ico.classList.remove("activeTime");
sun_ico.classList.remove("activeTime");
night_ico.classList.add("activeTime");
}
}

Deftheme();

//const gridHelper = new THREE.GridHelper(200,50);
//scene.add(gridHelper)

sun_ico.addEventListener('click', function() {
  sun_ico_trigger = true;
  scene.clear();
  time = 10;
  loader.load( 'SAPINS.glb', function ( gltf ) {
    gltf.scene.scale.set(6,6,6)
    gltf.scene.translateX(-150)
    gltf.scene.translateZ(-16)
    gltf.scene.translateY(-16)
    object.push(gltf.scene) ;
    let modell =  gltf.scene;

    scene.add( modell );

  }, undefined, function ( error ) {

    console.error( error );

  } );
  Deftheme();
 });


 sunrise_ico.addEventListener('click', function() {
  sunrise_ico_trigger = true;
  scene.clear();
  time = 7;
  loader.load( 'SAPINS.glb', function ( gltf ) {
    gltf.scene.scale.set(6,6,6)
    gltf.scene.translateX(-150)
    gltf.scene.translateZ(-16)
    gltf.scene.translateY(-16)
    object.push(gltf.scene) ;
    let modell =  gltf.scene;

    scene.add( modell );

  }, undefined, function ( error ) {

    console.error( error );

  } );
  Deftheme();
 });

 sunset_ico.addEventListener('click', function() {
  sun_ico_trigger = true;
  scene.clear();
  time = 17;
  loader.load( 'SAPINS.glb', function ( gltf ) {
    gltf.scene.scale.set(6,6,6)
    gltf.scene.translateX(-150)
    gltf.scene.translateZ(-16)
    gltf.scene.translateY(-16)
    object.push(gltf.scene) ;
    let modell =  gltf.scene;

    scene.add( modell );

  }, undefined, function ( error ) {

    console.error( error );

  } );
  Deftheme();
 });

  night_ico.addEventListener('click', function() {

  scene.clear();
  time = 21;
  loader.load( 'SAPINS.glb', function ( gltf ) {
    gltf.scene.scale.set(6,6,6)
    gltf.scene.translateX(-150)
    gltf.scene.translateZ(-16)
    gltf.scene.translateY(-16)
    object.push(gltf.scene) ;
    let modell =  gltf.scene;

    scene.add( modell );

  }, undefined, function ( error ) {

    console.error( error );

  } );
  Deftheme();
 });



const controls = new OrbitControls(camera,renderer.domElement);

controls.autoRotate = true;
controls.autoRotateSpeed = 1.5;







function animate() {
  requestAnimationFrame(animate);
  snows.forEach(snow => (snow.position.y > -50) ? snow.position.y -=0.2   : snow.position.y = Math.random() * 100
    );

   // console.log(camera.position);
    camera.rotateOnAxis( 5 );

  controls.update();

  renderer.render(scene,camera);
}
animate()
console.log(camera.position);


}




const initBackgroundHomePage = () => {

  if (document.querySelector('#bg')) {
    createBackground()
  }
}


export { initBackgroundHomePage };
