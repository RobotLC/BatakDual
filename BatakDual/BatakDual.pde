import processing.video.*;
import processing.serial.*;
import ddf.minim.*;

Minim minim;
AudioPlayer WinnerSound;
AudioPlayer ScoringSound;
AudioPlayer backSound;
float volume=0.0;
Boolean VolumeUp=false;
Boolean VolumeDown=false;


Serial myPort;  // Create object from Serial class
int SerialData;      // Data received from the serial port
Boolean flagPort= false;
String StringSerial;
Movie movie;

PImage back;
PImage backLogo;
PImage backInstrucciones;
PImage overlay;
PImage backStarting;
PImage backGame;
PImage backWinner;
PImage redWin;
PImage blueWin;
PImage tie;

int RedPoints=0;
int BluePoints=0;
Boolean flagWinner=false;

PImage Logo;
String Comenzar= "Presiona el botón de la derecha para comenzar";
Boolean flagZUP=true;
int Z=0;
int screen=0;
CountDownTimer StartingTimer;
CountDownTimer InstruccionesTimer;
CountDownTimer WinnerTimer;
Timer GameTimer;

PFont ubuntu;

void setup(){
  size(1920,1080, P3D);
  //imageMode(CENTER);
  ubuntu = createFont("Ubuntu-Bold.ttf", 256);
  textFont(ubuntu);
  
  back=loadImage("fondo.png");
  back.resize(width, height);
  backLogo=loadImage("FondoLogo.png");
  backLogo.resize(width, height);
  backWinner=loadImage("Winner.png");
  backWinner.resize(width, height);
  backGame=loadImage("backGame.png");
  backGame.resize(width, height);
  backStarting=loadImage("FondoStarting.png");
  backStarting.resize(width, height);
  backInstrucciones=loadImage("BackInstrucciones.png");
  backInstrucciones.resize(width, height);
  overlay=loadImage("overlay.png");
  overlay.resize(width, height);
  redWin=loadImage("ganadorrojo.png");
  blueWin=loadImage("ganadorazul.png");
  tie=loadImage("Empate.png");
  //Logo=loadImage("logo-wos.png");
  //Logo.resize(Logo.width/2,Logo.height/2);
  StartingTimer= new CountDownTimer(5000);
  InstruccionesTimer= new CountDownTimer(15000);
  WinnerTimer= new CountDownTimer(15000);
  StartingTimer= new CountDownTimer(5000);
  GameTimer= new Timer(60000);
  movie = new Movie(this, "plancha.mp4");
  //movie.loop();
  
  /////////////////Serial Port
  String [] PortsArray=Serial.list();
  for(int i=0; i<PortsArray.length;i++){
    if(PortsArray[i].toLowerCase().indexOf("usb") >= 0){
      println(PortsArray[i]);
      myPort = new Serial(this, PortsArray[i], 115200);
      flagPort=true;
    }
  }
  
    minim = new Minim(this);
    backSound = minim.loadFile("backMusic.mp3", 2048);
    WinnerSound = minim.loadFile("WinningSound.mp3", 2048);
    ScoringSound = minim.loadFile("Scoring.mp3", 2048);
     backSound.loop();
     WinnerSound.play();
     //ScoringSound.play();
     VolumeUp=true;;
     VolumeDown=false;
  
}

void draw(){
  background(back);
  if(flagPort){
    switch(screen){
      case 0: 
        Idle();
        break;
      case 1:
        Instructions();
        break;
      case 2:
        Video();
        break;
      case 3: 
        Starting();
        break;
      case 4:
        Game();
        break;
      case 5:
        Winner();
        break;  
      default:
        Idle();
        break;
    }
  }
  else{
    textSize(64);
    text("Revisa la conexión del puerto serial o contacta a soporte técnico", width/2-600,height/2-100,1200,200);
  }
  VolumeChange();
}

void Winner(){
   background(backWinner);
}

void Instructions(){
  background(backInstrucciones);
  int counter=int((15000-InstruccionesTimer.ellapsedTime())/1000);
  if(counter<=0){

  }
}

void Starting(){
  background(backStarting);
  int counter=int((5000-StartingTimer.ellapsedTime())/1000);
  if(counter<=0){
    screen=4;
    GameTimer.start();
    ///////////Secuencia previa al juego
    myPort.write('G');
    if (myPort.available() > 0) {  // If data is available,
      SerialData = myPort.read();         // read it and store it in val
      if(SerialData == 'O' || SerialData == 'K' ){
        screen=2;
        movie.play();
        VolumeDown=true;
      }
    }
  }  
}

void DisplayTimer(){
  int Timer=GameTimer.timeleft();
  int Minutes=(Timer/1000)/60;
  int Seconds=(Timer/1000)%60;
  int miliseconds=(Timer%1000)/10;
  String MM="";String SS=""; String ms="";
  if(Minutes<10){MM="0"+str(Minutes);}else{MM=str(Minutes);}
  if(Seconds<10){SS="0"+str(Seconds);}else{SS=str(Seconds);}
  if(miliseconds<10){ms="0"+str(miliseconds);}else{ms=str(miliseconds);}
  textSize(224);
  text(MM+":"+SS, width*.69,height*.9);
  textSize(96);
  text("."+ms, width*.87,height*.88);
  pushMatrix();
    float anglelogo = radians(180);
    translate(width, height);
    rotate(anglelogo);
    textSize(96);
    text("pts",width*.29,height*.87);
    textSize(224);
    text(MM+":"+SS, width*.68,height*.89);
    textSize(96);
    text("."+ms, width*.86,height*.87);
  popMatrix();
}

void Game(){
  background(backGame);
  int Timer=GameTimer.timeleft();
  if(Timer>0){
    DisplayTimer();
    ////////////////Secuencia del juego
    myPort.write('P');
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
          RedPoints=int(StringSerial.substring(0,index));
          BluePoints=int(StringSerial.substring(index+1,StringSerial.length()-1));
        }
      }
    }
    //if(frameCount%9==0){RedPoints++;}
    //if(frameCount%8==0){BluePoints++;} 
  }
  String SRP="";
  String SpacesRed="";
  if(RedPoints<10){SpacesRed="  ";}else if(RedPoints<100){SpacesRed=" ";}
  SRP=SpacesRed+str(RedPoints);
  String SBP="";
  String SpacesBlue="";
  if(BluePoints<10){SpacesBlue="  ";}else if(BluePoints<100){SpacesBlue=" ";}
  SBP=SpacesBlue+str(BluePoints);
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
  if(Timer<=0){
    if(!flagWinner){
      WinnerTimer.start(15000);
      VolumeDown=true;
      WinnerSound.rewind();
      WinnerSound.play();
      flagWinner=true;
    }
    if(!WinnerSound.isPlaying()){
      VolumeUp=true;
    }
    if(RedPoints>BluePoints){
      image(redWin,width*.375,height*.7);
    }
    else if(RedPoints<BluePoints){
      pushMatrix();
        anglelogo = radians(180);
        translate(width, height);
        rotate(anglelogo);
        image(blueWin,width*.35,height*.65);
      popMatrix();
    }
    else{
      image(tie,width*.375,height*.7);
      pushMatrix();
        anglelogo = radians(180);
        translate(width, height);
        rotate(anglelogo);
        image(tie,width*.35,height*.65);
      popMatrix();
    }
    int counter=int((15000-WinnerTimer.ellapsedTime())/1000);
    if(counter<=0){
      screen=0;
      myPort.write('E');
      VolumeUp=true;
    }
  }
}

void Video(){
  image(movie, 0, 0, width, height);
  image(back,0,0);
  if (movie.time()+1>=movie.duration()){
    screen=3;
    StartingTimer.start(5000);
    VolumeUp=true;
  }
}

void Idle(){
  background(backLogo);
  textSize(64);
  textAlign(CENTER, BOTTOM);
  text(Comenzar, width/2 , height*.85,Z);
  
  pushMatrix();
  float angle1 = radians(180);
  translate(width/2 , height*.15,Z);
  rotate(angle1);
  text(Comenzar, 0 , 0);
  popMatrix();
  
  if(Z>25){flagZUP=false;}
  if(Z<0){flagZUP=true;}
  if(flagZUP){Z++;}else{Z--;}
  ///////////////////////////////////Serial IDLE
  myPort.write('I');
  if(myPort.available() > 0){  // If data is available,
    SerialData = myPort.read();         // read it and store it in val
    if(SerialData == 'S'){
      screen=1;
      InstruccionesTimer.start(15000);
      movie.jump(0.01);
      movie.pause();
      VolumeUp=true;
      flagWinner=false;
    }
  }

}

void keyPressed(){
  if(key == '1'){
    screen=1;
    InstruccionesTimer.start(15000);
    movie.jump(0.01);
    movie.pause();
    VolumeUp=true;
  }
  if(key == '0'){
    screen=0;
  }
  if(key == '2'){
    screen=2;
    movie.play();
    VolumeDown=true;
  }
  if(key == '3'){
    screen=3;
    StartingTimer.start(5000);
  }
  if(key == '4'){
    screen=4;
    GameTimer.start();
  }
}

void movieEvent(Movie m) {
  m.read();
}


///////////////////MUSIC//////////////////////
void VolumeChange(){
  if(VolumeUp){
    backSound.shiftGain(backSound.getGain(),-10,2000);
    VolumeUp=false;
  }
  if(VolumeDown){
    backSound.shiftGain(backSound.getGain(),-80,1000);
    VolumeDown=false;
  }
  //println(backSound.getGain());
}

//////////////////MUSIC ENDS//////////////////////

void mousePressed(){
  println("Coords "+mouseX+" "+mouseY);
}

//////////////////////Serial Communication
/*
    
    if ( myPort.available() > 0) {  // If data is available,
      val = myPort.read();         // read it and store it in val
    }
    Idle
      I -> S tart
      I -> N one
    Game
      G -> Ok -else {G}
    Points
      P -> XX,XX;
    End
      E -> Ok -else {G}
    myPort.write('H'); 
    
    ///////////Secuencia Idle
    myPort.write('I');
    if(myPort.available() > 0){  // If data is available,
      SerialData = myPort.read();         // read it and store it in val
      if(SerialData == 'S'){
        screen=1;
        InstruccionesTimer.start(15000);
        movie.jump(0.0);
      }
    }
    
    ///////////Secuencia previa al juego
    myPort.write('G');
    if (myPort.available() > 0) {  // If data is available,
      SerialData = myPort.read();         // read it and store it in val
      if(SerialData == 'O' || SerialData == 'K' ){
        screen=2;
        movie.play();
      }
    }
    
    ////////////////Secuencia del juego
    myPort.write('P');
    if(myPort.available() > 0) {  // If data is available,
      StringSerial = myPort.readStringUntil(";");         // read it and store it in val
      
    }
    
    myPort.write('E');
    if ( myPort.available() > 0) {  // If data is available,
      val = myPort.read();         // read it and store it in val
    }
    
    
    
    
    
*/
