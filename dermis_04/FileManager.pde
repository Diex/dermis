import de.looksgood.ani.*;
import java.nio.file.*;
import java.util.Arrays;
import java.util.*;

String path;
String backupPath = "/data/imgs/backup"; 
String inboxPath = "/data/imgs/inbox";
String emailsPath = "/data/";


File bfolder;
File ifolder;

Ani listFolders;
float time1 = 10;
float timeOut1 = 0;



ArrayList<SkinMark> imagesInbox;
ArrayList<SkinMark> imagesBackup;

int maxBackup = 9 * 5; //45 maximo de la pantalla

void fileManager() {  
  imagesInbox = new ArrayList<SkinMark>();
  imagesBackup = new ArrayList<SkinMark>();  
  path = sketchPath();
  setupFolders();
  processInbox();
  loadImagesFromBackup();
}



SkinMark fromInbox() {
  if (imagesInbox.size() > 0) {
    SkinMark sm = imagesInbox.get(0);
    imagesInbox.remove(0);
    return sm;
  } else {
    println("no mas imagenes en inbox");
    return null;
  }
}

SkinMark fromBackup() {
  if (imagesBackup.size() <= 0) loadImagesFromBackup();  
  SkinMark sm = imagesBackup.get(0);
  imagesBackup.remove(0);
   println("image from backup");
  return sm;
}


void loadImagesFromBackup() {
  int howMany = bfolder.list().length > maxBackup ? maxBackup : bfolder.list().length;
  println(howMany);
  File[] files = bfolder.listFiles();
  Arrays.sort(files, new Comparator<File>() {
    public int compare(File f1, File f2) {
      return Long.valueOf(f2.lastModified()).compareTo(f1.lastModified()); //reversed
    }
  }
  );  
  
  if(files.length <= 0) return;
  
  for (int i = 0; i < howMany; i++) {
    if (isJpg(files[i].getPath())) {
      PImage p = loadImage(files[i].getPath());
      String email = files[i].getName().split("_")[0];
      imagesBackup.add(new SkinMark(p, email, true));
    }
  }
  println(imagesBackup.size() + " imagenes agregadas a backup");
}

void processInbox() {
  listFolders = new Ani(this, time1, "timeOut1", 1.0, Ani.LINEAR, "onEnd:processInbox");
  loadImagesFromInbox();
}

void loadImagesFromInbox() {
  int addedCount = 0;
  if (ifolder.list().length > 0) {
    File[] files = ifolder.listFiles();    
    for (int i = 0; i < files.length; i++) {
      if (isJpg(files[i].getPath())) {
        PImage p = loadImage(files[i].getPath());
        String email = files[i].getName().split("_")[0];
        imagesInbox.add(new SkinMark(p, email, false));      
        addedCount++;
        Path src = FileSystems.getDefault().getPath(files[i].getPath());
        Path dest = FileSystems.getDefault().getPath(files[i].getPath().replace("inbox", "backup"));
        try {
          Files.copy(src, dest, StandardCopyOption.REPLACE_EXISTING);
          Files.delete(src);
        }
        catch(Exception e) {
          e.printStackTrace();
        }
      }
    }

    println(addedCount + " imagenes agregadas a inbox. inbox tiene: " + imagesInbox.size());
  }
}

boolean isJpg(String fileName) {
  int splitIn = fileName.lastIndexOf(".");      
  return fileName.substring(splitIn).equals(".jpg") || fileName.substring(splitIn).equals(".JPG");
}

void setupFolders() {
  bfolder = new File(path, backupPath);
  if (!bfolder.exists()) {
    bfolder.mkdirs();
    println("creating: " + bfolder.getPath());
  }

  ifolder = new File(path, inboxPath);
  if (!ifolder.exists()) {
    ifolder.mkdirs();
    println("creating: " + ifolder.getPath());
  }
}



void saveMailsList(ArrayList<Cell> cells, String imageName){
  Table table = new Table();
  for(Cell c : cells){
    TableRow row = table.addRow();
    if(c.sm.isBackup) continue;
    row.setString("email", c.sm.email);
  }
  saveTable(table, "data/"+imageName+".csv");  
}