import processing.video.*;
import controlP5.*;
Capture video;
PImage resized;
PImage captured;

Textfield input; 

final int screen_w = 1920/2;
final int screen_h = 1080/2;
final int IDLE = 0;
final int PHOTO = 1;
final int MAIL = 3;
final int THX = 4;


int state = IDLE;

PImage[] backgrounds;

void setup(){
  size(960, 540);
  backgrounds = new PImage[5];
  backgrounds[0] = loadImage("03.png");
  backgrounds[1] = loadImage("02.png");
  printArray(Capture.list());
  
  video = new Capture(this, 640, 400);
  
  video.start();  
  
  resized = createImage(216, 216, RGB);
  captured = createImage(640, 400, RGB);

  PFont font = createFont("arial",20);
  
  cp5 = new ControlP5(this);
  
 input =  cp5.addTextfield("input")
     .setSize(374,30)
     .setPosition(width/2-374/2,height - 70)
     .setLabel("ingrese su email")
     
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,0,0))
     .hide()
     ;
   

  textFont(font);
}  

// 1920 / 9 = 213
// 540 / 5 = 216 

boolean showInput = false;
ControlP5 cp5;
String textValue = "";
boolean photoTaken = false;
int flashTime = 0;

boolean thxGiven = false;
int thxTime = 0;

void draw(){

  switch(state){
    
    case IDLE:
    
    background(0);    
    image(backgrounds[0],0,0,width, height);    
    imageMode(CENTER);
    image(video, width/2, 10 + height/2, 378 , 236);
    imageMode(CORNERS);
    drawRect();
    break;
    
    case PHOTO:
    if(!photoTaken){
      background(255); // flash de 1 cuadro
      resized.copy(video, 120, 0, 400, 400, 0, 0, 216, 216);
      captured.copy(video,0,0,video.width, video.height,0,0,video.width, video.height);
      photoTaken = true;
      
    }else{
        state = MAIL;
        photoTaken = false;
      
    }
    drawRect();
    
    break;
    
    case MAIL:
    background(0);    
    image(backgrounds[0],0,0,width, height);    
    imageMode(CENTER);
    image(video, width/2, 10 + height/2, 378 , 236);
    imageMode(CORNERS);
    break;
    
    case THX:
    if(!thxGiven){
      image(backgrounds[1],0,0,width, height);
      thxTime = 0;
      thxGiven = true;
    }else{
      thxTime ++;
      if(thxTime > 60 * 3){
        state = IDLE;
        thxGiven = false;
      }
    }
      
    break;
    
    

    
  }
  
        

}


void drawRect(){
  noStroke();
      fill(255);
      rectMode(CENTER);
      rect(width/2, height - 70 , 400, 100);
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
    println("controlEvent: accessing a string from controller '"
            +theEvent.getName()+"': "
            +theEvent.getStringValue()
            );
     
  }
  
  textValue = theEvent.getStringValue();
  String name = Long.toHexString(Double.doubleToLongBits(Math.random()));
  resized.save("./saved/"+textValue+"_"+name+".jpg");
  hideInput();
  state = THX;
}


public void input(String theText) {
  println("a textfield event for controller 'input' : "+theText);
}




void keyPressed(){
  //if(key == ' ') showInput();
  if(key != ' ') {
  
  } else{
    
    if(state == THX) {
      state = IDLE;
      return;
    }
    
    state = PHOTO;
    showInput();
  }
}

void showInput(){
  showInput = true;
  input.setFocus(true);
  input.show();
}

void hideInput(){
  showInput = false;
  input.hide();
}


void captureEvent(Capture c){
  if(!showInput) c.read();
}
