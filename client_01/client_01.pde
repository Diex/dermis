import processing.video.*;
import controlP5.*;
Capture video;
PImage resized;

Textfield input; 
PImage background;
PImage over;

final int screen_w = 1920/2;
final int screen_h = 1080/2;

void setup(){
  size(960, 540);
  video = new Capture(this, 640, 480);
  video.start();  
  
  resized = createImage(216, 216, RGB);
  background = loadImage("piel.jpg");  
  PFont font = createFont("arial",20);
  
  cp5 = new ControlP5(this);
  
 input =  cp5.addTextfield("input")
     .setPosition(width/2-200,height - 100)
     .setLabel("ingrese su email")
     .setSize(400,40)
     .setFont(font)
     .setFocus(true)
     .setColor(color(255,0,0))
     .hide()
     ;
   
  over = loadImage("over.png");
  textFont(font);
}  

// 1920 / 9 = 213
// 540 / 5 = 216 

boolean showInput = false;



ControlP5 cp5;

String textValue = "";



void draw(){
    background(0);    
    image(background,0,0, width, height);    
    imageMode(CENTER);
    image(video, width/2, height/2);
    imageMode(CORNERS);
    resized.copy(video, video.width/2 - 216, video.height/2 - 216, 432, 432, 0, 0, 216, 216);    
    image(over,0,0,width, height);        
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
}


public void input(String theText) {
  println("a textfield event for controller 'input' : "+theText);
}




void keyPressed(){
  if(key == ' ') showInput();
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
