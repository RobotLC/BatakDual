import processing.video.*;
import processing.serial.*;

PImage back;
Movie intro;


PImage logo;
PImage tarjetas;
PImage logopuntos;
int lw=400/2;
int lh=168/2;
int tw=540/2;
int th=264/2;
int lpw=320/2;
int lph=126/2;
int row0=180/2;
int lastrow=960-(160/2);

PFont ubuntu;

void setup(){
  //size(1920,1080, P3D);
  //size(1080,1920, P3D);
  size(540,960, P3D);
  imageMode(CENTER);
  back=loadImage("back.jpg");
  back.resize(width, height);
  intro = new Movie(this, "OUT.mp4");

  
  ubuntu = createFont("Ubuntu-Bold.ttf", 256);
  textFont(ubuntu);
  
  logo=loadImage("logo.png");
  logo.resize(lw,lh);
  tarjetas=loadImage("tarjetas.png");
  tarjetas.resize(tw,th);
  logopuntos=loadImage("logopuntos.png");
  logopuntos.resize(lpw,lph);
}

void draw(){
  background(back);
  playintro();
//  image(logo,width/4,row0);
//  image(tarjetas,width*3/4,row0);
//  image(logopuntos,width/2,lastrow);
  
}

void playintro(){
  image(intro,width/2,height/2,width,height);
  if(intro.isPlaying()){
    
  }
}

void movieEvent(Movie m) {
  m.read();
}

void keyPressed(){
  if (!intro.isPlaying()){
    intro.play();
  }
}
