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
