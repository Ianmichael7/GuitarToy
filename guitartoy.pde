//Code by Ian Ford, sounds accredited to 
import SimpleOpenNI.*;
import ddf.minim.*;
SimpleOpenNI context;
Minim minim;
AudioPlayer sound1, sound2, sound3, sound4, sound5, sound6;
AudioPlayer[] sound;

PFont f= createFont("Arial",32,true);
PVector bodyCenter = new PVector();
PVector bodyDir = new PVector();

//PImage bg = loadImage("INSERT BG IMAGE HERE");
PImage bg1 = loadImage("http://vimetech.weebly.com/uploads/1/9/0/1/1901133/487652_orig.png");
PImage bg2 = loadImage("http://vimetech.weebly.com/uploads/1/9/0/1/1901133/2374429_orig.png");
PImage bg3 = loadImage("http://vimetech.weebly.com/uploads/1/9/0/1/1901133/4181869_orig.png");
PImage bg4 = loadImage("http://vimetech.weebly.com/uploads/1/9/0/1/1901133/6955804_orig.png");
PImage bg5 = loadImage("http://vimetech.weebly.com/uploads/1/9/0/1/1901133/6988200_orig.png");
PImage bg6 = loadImage("http://vimetech.weebly.com/uploads/1/9/0/1/1901133/8194140_orig.png");
PImage left = loadImage("http://vimetech.weebly.com/uploads/1/9/0/1/1901133/4200046_orig.png");
PImage right = loadImage("http://vimetech.weebly.com/uploads/1/9/0/1/1901133/9699532_orig.png");
PImage button = loadImage("http://vimetech.weebly.com/uploads/1/9/0/1/1901133/98770_orig.png");

int i = 0;
int points = 0;
float leftX;
float leftY;
float rightX;
float rightY;
boolean playCheck = false;
float rotX = radians(180);

int[][] strings = { {130,140,-35,-640}, 
                    {200,210,-35,-640}, 
                    {270,280,-35,-640}, 
                    {350,360,-35,-640}, 
                    {425,435,-35,-640}, 
                    {500,510,-35,-640} };
String[] notes = {"E-High", "A", "B", "D", "G", "E-Low" };
boolean[] checks = {false, false, false, false, false, false};
String[] player = {"","","","","","" };
String[] ret = {"","","","","","" };

void setup()
{
  size(640,480,P3D);
  context = new SimpleOpenNI(this);
  minim = new Minim(this);
  
  sound1 = minim.loadFile("ELo.mp3");
  sound2 = minim.loadFile("A.mp3");
  sound3 = minim.loadFile("D.mp3");
  sound4 = minim.loadFile("G.mp3");
  sound5 = minim.loadFile("B.mp3");
  sound6 = minim.loadFile("EHi.mp3");
  
  AudioPlayer[] s = {sound1,sound2,sound3,sound4,sound5,sound6};
  sound = s;
  
  if(context.isInit() == false)
  {
     println("You're not Kinected!!"); 
     exit();
     return;
  }

  context.setMirror(false);
  context.enableDepth();
  context.enableUser();
}

String[] ran(){
  String[] ret = {notes[int(random(notes.length))], notes[int(random(notes.length))],
                  notes[int(random(notes.length))], notes[int(random(notes.length))],
                  notes[int(random(notes.length))], notes[int(random(notes.length))]};
  for(int r = 0; r<ret.length; r++) print(ret[r] + " ");
  return ret;
}

void draw()
{
  context.update();
  
  for(int b=0;b<context.getUsers().length;b++)
  {
    if(context.isTrackingSkeleton(context.getUsers()[b])) trackSkeleton(context.getUsers()[b]);
  }
  
  if(ret[0] == "") ret = ran();
  if(i == 6){
    print("WINNER: NEXT ROUND");
    ret = ran();
    for(int b = 0;b < player.length;b++) player[b] = "";
    i = 0;
    points++;
  }
  
  //image(bg,0,0); Activate once a background is loaded
  image(button,525,300);
  if(checks[0]) image(bg1, 0, 0);
  else if(checks[1]) image(bg2, 0, 0);
  else if(checks[2]) image(bg3, 0, 0);
  else if(checks[3]) image(bg4, 0, 0);
  else if(checks[4]) image(bg5, 0, 0);
  else if(checks[5]) image(bg6, 0, 0);
  
  int spot = 50;
  for(int r = 0;r<ret.length;r++){
    if(ret[r] == player[r]){
      textFont(f,36); fill(255,0,0);
      text(ret[r],10,spot);
    }
    else{
      textFont(f,36); fill(0,255,0);
      text(ret[r],10,spot);
    }
    spot += 50;
  }
  
  textFont(f,36); fill(255,0,0);
  text("POINTS: "+points,10,460);
  pushMatrix();
  rotateX(rotX);
  image(left, (int)leftX+500, (int)leftY);
  image(right, (int)rightX+500, (int)rightY);
  popMatrix();
}

void trackSkeleton(int userId)
{
  getLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_LEFT_HAND);
  getLimb(userId, SimpleOpenNI.SKEL_LEFT_ELBOW, SimpleOpenNI.SKEL_RIGHT_HAND);  
  bodyDir.mult(200);
  bodyDir.add(bodyCenter);
}

void getLimb(int userId,int jointType1,int jointType2)
{
  PVector jointPos1 = new PVector();
  PVector jointPos2 = new PVector();
  float  confidence;

  confidence = context.getJointPositionSkeleton(userId,jointType1,jointPos1);
  confidence = context.getJointPositionSkeleton(userId,jointType2,jointPos2);
  
  if(jointType2 == SimpleOpenNI.SKEL_LEFT_HAND){
       float[] jacob = jointPos2.array();
       leftX = jacob[0]; leftY = jacob[1];
       for(int z = 0; z < strings.length;z++){
            int[] temp = strings[z];
            if(leftX+500 <= temp[0] && leftX+500+64 >= temp[1] && leftY <= temp[2] && leftY+64 >= temp[3] && !checks[z] && !playCheck){ checks[z] = true; sound[z].rewind(); sound[z].play();
              if(z == 0){ if(ret[i] == "E-Low"){player[i] = "E-Low"; i++;} else{i = 0; for(int b = 0;b < player.length;b++) player[b] = "";}}
              else if(z == 1){ if(ret[i] == "A"){player[i] = "A"; i++;} else{i = 0; for(int b = 0;b < player.length;b++) player[b] = "";}}
              else if(z == 2){ if(ret[i] == "D"){player[i] = "D"; i++;} else{i = 0; for(int b = 0;b < player.length;b++) player[b] = "";}}
              else if(z == 3){ if(ret[i] == "G"){player[i] = "G"; i++;} else{i = 0; for(int b = 0;b < player.length;b++) player[b] = "";}}
              else if(z == 4){ if(ret[i] == "B"){player[i] = "B"; i++;} else{i = 0; for(int b = 0;b < player.length;b++) player[b] = "";}}
              else if(z == 5){ if(ret[i] == "E-High"){player[i] = "E-High"; i++;} else{i = 0; for(int b = 0;b < player.length;b++) player[b] = "";}}
              print("GOAL: "); for(int r = 0; r<ret.length; r++) print(ret[r] + " ");
              print("CURRENT GO: "); for(int r = 0; r<player.length; r++) print(player[r] + " ");
              print("\n");
            }
            else if(leftX+500 <= temp[0] && leftX+500+64 >= temp[1] && leftY <= temp[2] && leftY+128 >= temp[3] && checks[z]) checks[z] = true;
            else{checks[z] = false;}
       }
  }
  else if(jointType2 == SimpleOpenNI.SKEL_RIGHT_HAND){
       float[] jacob = jointPos2.array();
       rightX = jacob[0]; rightY = jacob[1];
       if(rightY+500 <= 115 && rightY+500+64 >= 0 && rightX+500 <= 640 && rightX+500+64 >= 525) playCheck = true;
       else playCheck = false;
  }
}

void onNewUser(SimpleOpenNI curContext,int userId)
{
  println("NEW PERSON!");
  context.startTrackingSkeleton(userId);
}
