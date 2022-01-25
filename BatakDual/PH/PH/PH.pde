import processing.video.*;
import processing.serial.*;
import ddf.minim.*;

///////////////////Movies
Movie intro;
Movie outro;

///////////////////Audios
Minim minim;
AudioPlayer backSound;

///////////////////Images
PImage back;
PImage logo;
PImage tarjetas;
PImage logopuntos;

/////////////////////General Colors and Fonts
color PHYellow = color(255, 204, 0);
color PHGrey = color(94, 91, 91);
color PHLightGrey = color(206, 205, 206);

PFont ubuntu;

////////////////////Position for rows
int row0=180/2;
int row2=480/2;
int lastrow=960-(160/2);
int rowcircle=1000/2;
int rowcircle2=1200/2;
int rowTimer0=1100/2;
int rowTimer1=1100/2;
int rowTimer2=1340/2;
int rowTimerCircle=1280/2;
int rowGame0=360/2;
int rowGame1=420/2;
int rowGame2=800/2;

//////////////////Player selection
int P2=160/2;
int P1=160/2;
int D1=200/2;
int D2=560/2;
int D3=1600/2;
int D4=4000;
int circle=0;
int alpha=0;

boolean flagJugadores=false;
boolean flagPlayer=false;
boolean flagPlayer2=false;

/////////////////////////Game
boolean flagGame=false;
int P1Points=0;
int P2Points=0;
int arcaux=30;
float val = 0;
int counter=0;
boolean flagGameEnd=false;

////////////////////////SerialPort
Serial myPort;  // Create object from Serial class
int SerialData;      // Data received from the serial port
Boolean flagPort= false;
String StringSerial;



/////////////////////Timers
CountDownTimer StartingTimer;
CountDownTimer InstruccionesTimer;
CountDownTimer WinnerTimer;
Timer GameTimer;


void setup(){
  //size(1080,1920, P3D);
  size(540,960, P3D);
  ////////////////////////////IMAGES
  imageMode(CENTER);
  back=loadImage("back.jpg");
  back.resize(width, height);
  ////////////////////////////VIDEOS
  intro = new Movie(this, "intro3.mp4");
  intro.play();
  outro = new Movie(this, "outro.mp4");
  outro.play();
  outro.pause();
  /////////////////////////////AUDIOS
  minim = new Minim(this);
  backSound = minim.loadFile("backMusic.mp3", 2048);
  ////////////////////////////FONTS  
  ubuntu = createFont("Ubuntu-Bold.ttf", 256);
  textFont(ubuntu);
  ////////////////////////////TIMERS
  StartingTimer= new CountDownTimer(5000);
  InstruccionesTimer= new CountDownTimer(15000);
  WinnerTimer= new CountDownTimer(15000);
  StartingTimer= new CountDownTimer(5000);
  GameTimer= new Timer(33000);
  
  /////////////////Serial Port
  String [] PortsArray=Serial.list();
  for(int i=0; i<PortsArray.length;i++){
    if(PortsArray[i].toLowerCase().indexOf("usb") >= 0  ||  PortsArray[i].toLowerCase().indexOf("acm") >= 0){
      println(PortsArray[i]);
      myPort = new Serial(this, PortsArray[i], 115200);
      flagPort=true;
    }
  }
  //flagGame=true;
  //GameTimer.start();
}

void draw(){
  background(back);
  if(!flagPort){
    if(!flagJugadores && !flagGame){
      playintro();
    }
    if(flagJugadores){
      jugadores();
    }
    if(flagGame){
      Game();
    }
    if(flagGameEnd){
      playoutro();
    }
  }
  else{
    textSize(40);
    textAlign(CENTER,CENTER);
    text("Revisa la conexión del tablero de botones o contacta a soporte técnico", 0,0,width,height);
  }
}

void Game(){
  background(back);
  int Timer=GameTimer.timeleft();
  if(frameCount%25==0 && Timer>3000){counter++;}
  if(Timer>0){
    int smalltextgame=32;
    int bigtextgame=96;
    fill(255);
    textSize(smalltextgame);
    text("HAS ATRAPADO", 0, rowGame0, width, smalltextgame*2);
    textSize(bigtextgame);
    fill(PHYellow);
    text(str(counter), 0, rowGame1, width, bigtextgame*2);
    String puntos;
    if(counter==1){puntos="PUNTO";}else{puntos="PUNTOS";}
    fill(255);
    textSize(smalltextgame);
    text(puntos, 0, rowGame2, width, smalltextgame*2);
    
    DisplayTimer();
    noFill();
    strokeWeight(12);
    stroke(PHLightGrey);
    ellipse(width/2,rowTimerCircle,220,220);
    arcaux=30000-Timer+3000;
    val = 2*PI*arcaux/30000;
    println(arcaux);
    stroke(PHYellow);
    strokeWeight(12);
    arc(width/2,rowTimerCircle, 220, 220, 0, val);
  }
  else{
    flagGameEnd=true;
    flagGame=false;
    outro.play();
  }
  ////////////////Secuencia del juego
    /*myPort.write('P');
    while (myPort.available() > 0) {  // If data is available,
        StringSerial = myPort.readStringUntil(';');         // read it and store it in val
        SerialData=myPort.read();
        println(StringSerial);
        int index=0;
        if(StringSerial!=null){
          if(StringSerial.length()>0){
            index=StringSerial.indexOf(",");
            println(index);
        }
        if(index>0){
          println("Red"+StringSerial.substring(0,index)+" , Blue "+StringSerial.substring(index+1,StringSerial.length()-1));
          P1Points=int(StringSerial.substring(0,index));
          P2Points=int(StringSerial.substring(index+1,StringSerial.length()-1));
        }
      }
    }
    //if(frameCount%9==0){RedPoints++;}
    //if(frameCount%8==0){BluePoints++;} 
  }
  String SRP="";
  String SpacesRed="";
  if(P1Points<10){SpacesRed="  ";}else if(P1Points<100){SpacesRed=" ";}
  SRP=SpacesRed+str(P1Points);
  String SBP="";
  String SpacesBlue="";
  if(P2Points<10){SpacesBlue="  ";}else if(P2Points<100){SpacesBlue=" ";}
  SBP=SpacesBlue+str(P2Points);
  pushMatrix();
    float anglelogo = radians(180);
    translate(width, height);
    rotate(anglelogo);
    textSize(224);
    text(SBP,width*.155,height*.89);
    textSize(96);
    text("pts",width*.29,height*.87);
  popMatrix();
  textSize(224);
  text(SRP,width*.165,height*.9);
  textSize(96);
  text("pts",width*.3,height*.88);
  */
}

void DisplayTimer(){
  int Timer=GameTimer.timeleft();
  int Minutes=(Timer/1000)/60;
  int Seconds=(Timer/1000)%60-3;
  int miliseconds=(Timer%1000)/10;
  if(Seconds<0){Seconds=0;}
  String MM="";String SS=""; String ms="";
  if(Minutes<10){MM="0"+str(Minutes);}else{MM=str(Minutes);}
  if(Seconds<10){SS="0"+str(Seconds);}else{SS=str(Seconds);}
  if(miliseconds<10){ms="0"+str(miliseconds);}else{ms=str(miliseconds);}
  int smallText=20;
  int bigText=72;
  fill(255);
  textAlign(CENTER,CENTER);
  if(Seconds!=1){
    textSize(smallText);
    text("QUEDAN",0,rowTimer0,width,smallText*2);
    textSize(bigText);
    text(SS,0,rowTimer1,width,bigText*2);
    textSize(smallText);
    text("SEGUNDOS",0,rowTimer2,width,smallText*2);
  }else{
    textSize(smallText);
    text("QUEDA",0,rowTimer0,width,smallText*2);
    textSize(bigText);
    text(SS,0,rowTimer1,width,bigText*2);
    textSize(smallText);
    text("SEGUNDO",0,rowTimer2,width,smallText*2);  }
                
}

void playintro(){
  image(intro,width/2,height/2,width,height);
  if(!intro.isPlaying()){
    image(back,width/2,height/2);
  }
  //println(intro.time() + " " + intro.duration());
  if(intro.time()+.05 >= intro.duration()){
    intro.jump(0);
    flagJugadores=true;
  }
}

void playoutro(){
  image(outro,width/2,height/2,width,height);
  if(!outro.isPlaying()){
    image(back,width/2,height/2);
  }
  //println(intro.time() + " " + intro.duration());
  if(outro.time()+.05 >= outro.duration()){
    outro.jump(0);
    resetPlayers();
    flagGameEnd=false;
    intro.play();
    flagJugadores=false;
    flagGame=false;
  }
}

void jugadores(){
  textSize(40);
  circle+=20;
  if(flagPlayer && circle>D3){
    P1+=10;
  }
  if(flagPlayer2 && circle>D3){
    P2+=10;
  }
  if(circle>D3){
    textAlign(CENTER);
    fill(255, 255, 255);
    text("JUGADORES",0,row2,width,row2*2);
  }
  if(circle>D2){
    fill(PHYellow);
    //ellipse(width/2,rowcircle2,P2,P2);
    ellipse(width/2+100,rowcircle2,P2,P2);
    if(P1<400){fill(PHGrey);}else{fill(PHYellow);}
    //text("2",0,rowcircle2-20,width,rowcircle2+20);
    textAlign(CENTER,CENTER);
    text("2",width/2+100,rowcircle2-5);
  }
  if(circle>D2){
    fill(PHYellow);
    //ellipse(width/2,rowcircle,P1,P1);
    ellipse(width/2-100,rowcircle2,P1,P1);
    if(P2<400){fill(PHGrey);}else{fill(PHYellow);}
    textAlign(CENTER,CENTER);
    text("1",width/2-100,rowcircle2-5);
  }
  if(circle>D4 && !flagPlayer && !flagPlayer2){
    alpha+=5;
    tint(255,alpha);
    image(back,width/2,height/2);
    if(alpha>255){
      resetPlayers();
    }
  }
  if(P2>D4/2 || P1>D4/2){
    alpha+=5;
    tint(255,alpha);
    image(back,width/2,height/2);
    if(alpha>255){
      P1=160/2;P2=160/2;
      resetPlayers();
      flagGame=true;
      GameTimer.start();
    }
  }
  strokeWeight(60);
  stroke(PHYellow);
  noFill();
  ellipse(width/2,height*2/3,circle,circle);
  noStroke();
}

void resetPlayers(){
  alpha=0;
  circle=0;
  intro.jump(0);
  flagJugadores=false;
  flagPlayer2=false;
  flagPlayer=false;
}

void movieEvent(Movie m) {
  m.read();
}

void keyPressed(){
  if(key=='1'){
    if (!intro.isPlaying()){
      intro.jump(0);
      intro.play();
    }
  }
  
  if(key=='2'){
    //flagJugadores=true;
  }
  else if(key=='4'){
    flagPlayer=true;
  }
  else if(key=='5'){
    flagPlayer2=true;
  } 
  else{
    //flagJugadores=false;
  }  
}
