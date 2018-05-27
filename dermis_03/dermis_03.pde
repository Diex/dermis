import processing.video.*;
import de.looksgood.ani.*;

int cols = 9;
int rows = 5;
Movie transition;
Locations locs;
ArrayList<Cell> cells = new ArrayList<Cell>();

int cellsToShow;
boolean showVideo = false;

Ani nextImage;
float nextImg = 0;
float nextTimeout = 1;
void setup() {
  size(1920, 1080);
  transition = new Movie(this, "movie.mp4");
  locs = new Locations(width, height, cols, rows);  
  Ani.init(this);
  fileManager();
  cellsToShow = 45;
  next(); 
  noCursor();
}


void draw() {
  background(0);
  for (Cell c : cells) {
    c.render();
  }

  if (allShown()) {
    while (cells.size() > 0) {
      Cell c = cells.get(0);
      c = null;
      cells.remove(0);
    }
    println("all cleared");
    inFadeOut = false;
  }

  if (showVideo) {
    image(transition, 0, 0);
  }
}

void keyPressed(){
  if(key == ' ') next();
}


void hideAll() {
  
  String name = Long.toHexString(Double.doubleToLongBits(Math.random()));
  for (Cell c : cells) c.hide();
  if(!allBackup()){
    saveFrame("data/snapshots/"+name+".jpg");  
    saveMailsList(cells, name);
  }
  
}

boolean allBackup(){
  for (Cell c : cells) {
    if (c.sm.isBackup == false) return false;
  }
  if(cells.size() == 0) return false;
  return true;
}

boolean allShown() {
  for (Cell c : cells) {
    if (c.shown == false) return false;
  }
  if(cells.size() == 0) return false;
  return true;
}

void showVideo() {
  showVideo = true;
  transition.stop();
  transition.play();
}

boolean inFadeOut = false;
void next() {
  nextImage =  new Ani(this, nextTimeout, 0, "nextImg", 0, Ani.LINEAR, "onEnd:next");
  if(inFadeOut) return;
  
  if (cellsToShow == cells.size()) {    
    hideAll();
    inFadeOut = true;
    return;
  }
  
  Cell c = new Cell(getOneSkinMark(), locs.next(), locs.dim());
  c.show();
  cells.add(c);
}

void movieEvent(Movie m) {
  m.read();
}


SkinMark getOneSkinMark() {
  SkinMark sm = fromInbox(); 
  if ( sm == null) sm = fromBackup();
  return sm;
}