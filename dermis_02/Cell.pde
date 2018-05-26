class Cell {
  PImage img;
  float alpha = 0;
  PVector loc;
  PVector size;
  float fadeTime = 2;
  float fadeOutTime = 0.5;
  float fadeOutDelay = 0.5;
  SkinMark sm;
  boolean shown = false;

  Cell(SkinMark sm, PVector loc, PVector size) {
    this.sm = sm;
    this.loc = loc;
    this.size = size;
    fadeOutTime = random(1, 3);
    fadeOutDelay = random(0, 1);
  }

  void show() {
    Ani.to(this, fadeTime, "alpha", 1);
  }

  void hide() {
    Ani.to(this, fadeOutTime, fadeOutTime, "alpha", 0, Ani.EXPO_IN, "onEnd:shown");
  }

  void shown() {
    shown = true;
  }
  void render() {
    pushStyle();
    tint(255, alpha * 255);
    image(sm.img, loc.x, loc.y, size.x, size.y);
    popStyle();
  }
}
