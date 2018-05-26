import processing.video.*;
import de.looksgood.ani.*;
//int col_w;
//int row_h;
int cols = 9;
int rows = 5;

//ArrayList<PImage> images = new ArrayList<PImage>();
ArrayList<Cell> cells = new ArrayList<Cell>();

Movie transition;
//Cell img;
Locations locs;

void setup() {
  size(960, 540);
  //col_w = width/cols;
  //row_h = height/rows;
  transition = new Movie(this, "movie.mp4");

  locs = new Locations(width, height, cols, rows);
  
  String path = sketchPath();
  String[] filenames = listFileNames(path+"/data/img");

  for (int i = 0; i < filenames.length; i++) {
    if (filenames[i].contains(".jpg")) {
      PImage img = loadImage("img/"+filenames[i]);
      //images.add(img);
      cells.add(new Cell(img, locs.next(), locs.dim()));
    }
  }
  //showImages();
  //transition.play();
  //img = new Cell(images.get(0), new PVector(0, 0), new PVector(100, 100));
  // you have to call always Ani.init() first!
  Ani.init(this);
  
  
}



void draw() {
  background(0);
  for(Cell c : cells){
    c.render();
  }
  
  
  //image(transition, 0,0, width, height);
  //img.render();
  
}


void keyPressed() {
   int w = (int) random(cells.size());
   cells.get(w).show();
}

void movieEvent(Movie m) {
  m.read();
}

void showImages() {
  for (int x = 0; x < cols; x ++) {
    for (int y = 0; y < rows; y++) {
      //PImage img = images.get((int) random(images.size()));
      //image(img, x*col_w, y*row_h, col_w, row_h);
    }
  }
}





class Cell {
  public static final int IDLE = 0;
  public static final int FADE_IN = 1;
  public static final int FADE_OUT = -1;

  PImage img;
  float alpha = 0;
  int state = IDLE;
  PVector loc;
  PVector size;
  float fadeTime = 2;


  Cell(PImage image, PVector loc, PVector size) {
    this.img = image;
    this.loc = loc;
    this.size = size;
  }

  void show() {
    Ani.to(this, fadeTime, "alpha", 1);
  }

  void hide() {
    Ani.to(this, fadeTime, "alpha", 0);
  }

  void render() {
    pushStyle();
    tint(255, alpha * 255);
    image(img, loc.x, loc.y, size.x, size.y);
    popStyle();
  }
}

class Locations {
  java.util.ArrayList<PVector> urn;
  int col_w;
  int row_h;
  int w, h, cols, rows;
  PVector dim;
  
  Locations(int w, int h, int cols, int rows) {
    this.w = w;
    this.h = h;
    this.cols = cols;
    this.rows = rows;
    
    reset();
  }
  
  
  PVector dim(){
    return dim;
  }
  
  void reset() {
    col_w = w/cols;
    row_h = h/rows;
    dim = new PVector(col_w, row_h);
    urn = new ArrayList<PVector>();
    for (int x = 0; x < cols; x ++) {
      for (int y = 0; y < rows; y++) {
        urn.add(new PVector(x*col_w, y*row_h));
      }
    }
  }
  PVector next() {
    if(urn.size() == 0) reset();
    return urn.remove((int) random(urn.size()));
  }
}



// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}
