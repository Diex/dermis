class SkinMark{
  PImage img;
  String email;
  boolean shown = false;
  boolean isBackup = false;
 
  
  SkinMark(PImage image, String email, boolean isBackup){
    this.img = image;
    this.email = email;  
    this.isBackup = isBackup;
    println("created : " + email); 
  }
  
  
  
}
