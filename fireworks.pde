//Happy 4th of July
//7/4/17
//Code Sprint. 
//Start 5pm
//End 7pm

color fireworkColors[] = {#36faf5, #f43b2b, #3afa36,    //light blue, red, bright green
                          #9436fa, #fac536, #fa36cd,    //purple, gold, pink, 
                          #05c8c4};    //teal
int fireworkColors_size = 7;   
ArrayList <projectile> projectiles;
boolean auto;
PImage pine;
forest f;
ArrayList <PVector> stars;
int fontSize = 50;
bool fullscreen = false;

void setup(){
  
  
  fullscreen = document.getElementById("fullscreen").checked;

  if(fullscreen){
    size(window.innerWidth * .95, window.innerHeight * .95);
    document.getElementById("demo-showcase").style.position = "fixed";
    document.getElementById("demo-showcase").style.transform = "translateX(-50%)";

    document.getElementById("exit").style.position = "fixed";
    document.getElementById("exit").style.display = "block";
  }
  else{
    size(window.innderWidth * .95, 500); 
    document.getElementById("demo-showcase").style.position = "initial";
    document.getElementById("demo-showcase").style.transform = "translateX(0%)";
    document.getElementById("exit").style.display = "none";
  }

  fontSize = Math.min(width / 10, height / 10);
  frameRate(60);
  noStroke();
  projectiles = new ArrayList <projectile>();
  auto = true;
  pine = loadImage("small-tree.png");
  //pine.resize(50, 0);
  f = new forest(30);
  stars = new ArrayList <PVector>();
  for(int i = 0; i < 20; i++){
    PVector s = new PVector(random(width), random(0, height * .2));
    stars.add(s); 
  }
}

void draw(){
  //handle resize and full screen
  if(width != window.innerWidth * .95 || document.getElementById("fullscreen").checked != fullscreen){
      fullscreen = document.getElementById("fullscreen").checked;
      if(fullscreen){
        size(window.innerWidth * .95, window.innerHeight * .95);  
        document.getElementById("demo-showcase").style.position = "fixed";
        document.getElementById("demo-showcase").style.transform = "translateX(-50%)";
        document.getElementById("exit").style.position = "fixed";
        document.getElementById("exit").style.display = "block";
      }
      else{
        size(window.innerWidth * .95, 480);
        document.getElementById("demo-showcase").style.position = "initial";
        document.getElementById("demo-showcase").style.transform = "translateX(0%)";
        document.getElementById("exit").style.display = "none";
      }

      stars = new ArrayList <PVector>();
      for(int i = 0; i < 20; i++){
        PVector s = new PVector(random(width), random(0, height * .2));
        stars.add(s); 
      }
      fontSize = Math.min(width / 10, height / 10);
      f = new forest(30);
  }
  
  drawBackgroundSky();
  
  if(auto && (frameCount % 10) == 0){
    int tempX = int(random(width * 0.45, width * 0.55));
    projectiles.add(new projectile(tempX));
    //mousePressed();
  }
  
  //String message = "Great Job!";
  String message = document.getElementById("message").value;
  textSize(fontSize);
  textAlign(CENTER, CENTER);
  fill(#EE1D52, 255);
  text(message, width * .1, 0, width * .8 + (fontSize/12), height + (fontSize/12));   
  textSize(fontSize);
  textAlign(CENTER, CENTER);
  fill(#69C9D0, 255);
  text(message, width * .1, 0, width * .8 - (fontSize/12), height - (fontSize/12));  
  textSize(fontSize);
  textAlign(CENTER, CENTER);
  //fill(255, 51, 119, 200);
  fill(255, 255, 255, 255);
  text(message, width * .1, 0, width * .8, height);   
 
  String from = document.getElementById("from").value;
  if(from != ""){
    textSize(fontSize / 4);
    textAlign(LEFT);
    fill(#FFFFFF, 255);
    text("From: " + from, width * .05, height * .05);
  }

  String to = document.getElementById("to").value;
  if(to != ""){
    textSize(fontSize / 4);
    textAlign(RIGHT);
    fill(#FFFFFF, 255);
    text("To: " + to, width * .95, height * .05);
  }

  for(int i = 0; i < projectiles.size(); i++){
    if(!projectiles.get(i).isAlive()){
      if(!projectiles.get(i).isFlame()){
         int num_flames = int(random(10, 20));
         float v = 1;
         if(int(random(10)) == 0){ //random big one
           num_flames = int(random(20, 30));
           v = random(1.2, 2);
         }
         float angles[] = new float[num_flames];
         angles = getAngles(num_flames);
         color C = fireworkColors[int(random(fireworkColors_size))];
         for(int j = 0; j < num_flames; j++){
           projectiles.add(new flame(projectiles.get(i).x, projectiles.get(i).y, C, angles[j], v));
           projectiles.add(new flame(projectiles.get(i).x, projectiles.get(i).y, #FFFFFF, angles[j], v));
         }
      }
      projectiles.remove(i);
      i--;  
    }
  }
  for(int i = 0; i < projectiles.size(); i++){
    projectiles.get(i).move();
    projectiles.get(i).draw(); 
  }
  
  ellipseMode(CENTER);
  fill(#114611);
  ellipse(width/2, height, width * 1.4, 25);
  
  f.draw(#000000);
}

void mousePressed(){
  console.log("Mouse pressed");
  projectiles.add(new projectile(mouseX));
}

void keyPressed(){
  //auto = !auto; 
}

void drawBackgroundSky(){
  //sky
  background(0);
  for(int i = 0; i < 10; i ++){
     fill(0, i * (20 / 10), i * (40/ 10));
     rect(0, i * (height / 10), width, height / 10);
  }
  
  //stars
  for(int i = 0; i < stars.size(); i++){
    fill(#FFFFFF);
    rect(stars.get(i).x, stars.get(i).y, 2, 2);
  }
}

float[] getAngles(int num){
    float angles[] = new float[num];
    float increment = 360.0 / num;
    for(int i = 0; i < num; i++){
        angles[i] = i * increment; 
    }
    return angles;
}

class particle {
  public
    float x;
    float y;
    int w;
    int h;
    color c;
    int a;
    
    particle(){
       x = width / 2;
       y = height;
       w = 7;
       h = 7;
       c = fireworkColors[int(random(fireworkColors_size))];
       a = 255;
    }
        
    color draw(){
       fill(c, a);
       ellipse(x, y, w, h);
       return c;
    }
}

class projectile extends particle {
    float v;
    float acc; 
    float angle;
    
    projectile(){
       x = width / 2;
       y = height;
       c = #ffffff;
       a = 255;
       v = random(400, 700);
       acc = 10;
       angle = 0;
    }
    
    projectile(float X){
        x = X;
        y = height;
        c = #ffffff;
        a = 255;
        v = random(Math.min(400, height * .9), Math.max(700, height * 1.15 ));
        acc = 10;
        angle = randSign() * random(PI/2 * .9, PI/2 * 1.1);
    }
    
    boolean isFlame(){ return false;}
    
    void move(){
      y -= v / frameRate;
      x += sin(angle) * (50 / frameRate);
      v -= acc;
    }
    
    boolean isAlive(){
       if (v >= 0)
         return true;
       return false;
    }
    
    private
      int randSign(){
         if(int(random(2)) == 0)
           return -1;
          return 1;
      }
}

class flame extends projectile {
  
    flame(float X, float Y, color C, float Angle, float V){
       x = X;
       y = Y;
       c = C;
       a = 255;
       v = random(150, 300) * V;
       acc = 10;
       angle = Angle;
    }
    
    boolean isFlame(){ return true;}
    
    void move(){
      y -= cos(angle) * (v / frameRate);
      x += sin(angle) * (v / frameRate);
      v -= acc;
      a -= 10;
    }
}

class tree{
   int x; 
   int y;
   PImage im;
   
   tree(){
     x = width/2;
     y = height;
     im = pine;
   }
   
   tree(int X, int Y){
     x = X;
     y = Y;
     im = pine;
   }
   
   void draw(color c){
     //if(c != #000000)
       //tint(c);
     image(im, x, y);
   }
}

class forest{
   ArrayList <tree> trees;
   
   forest(int n){
      trees = new ArrayList <tree>();
      int j = 0;
      int row = 0;
      for(int i = 0; i < n; i++){
        /*if((row * pine.width/2) + j * (pine.width) > width) {
          j = 0;
          row++;
        }
        int r = (row * pine.width/2) + int(random(-1 * pine.width/2, pine.width/2));
        tree t = new tree((j * pine.width) + r, height - pine.height + int(random(-7, 7))); 
        trees.add(t);
        j++;*/
        tree t = new tree(random(0, width), height - 65 + int(random(-7, 7)));
        trees.add(t);
      }
   }
   
   void draw(color c){
      for(int i = 0; i < trees.size(); i++){
         trees.get(i).draw(c); 
      }
   }
}
