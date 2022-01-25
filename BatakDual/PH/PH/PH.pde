import processing.video.*;
import processing.serial.*;

PImage back;
PImage logo;
PImage tarjetas;
PImage logopuntos;


PFont ubuntu;

void setup(){
  //size(1920,1080, P3D);
  //size(1080,1920, P3D);
  size(540,960, P3D);
  //imageMode(CENTER);
  ubuntu = createFont("Ubuntu-Bold.ttf", 256);
  textFont(ubuntu);
  
  back=loadImage("PANTALLA.png");
  back.resize(width, height);
  logo=loadImage("logo.png");
  logo.resize(width/3,height/11);
  tarjetas=loadImage("tarjetas.png");
  tarjetas.resize(width/3,height/11);
  logopuntos=loadImage("logopuntos.png");
  logopuntos.resize(width/3,height/11);
  
 
}

void draw(){
  background(back);
  image(logo,width/4-logo.width/2,100);
  image(tarjetas,width-tarjetas.width*1.5,100);
  image(logopuntos,width/2-logopuntos.width/2,height-logopuntos.height*1.5);
  
}
