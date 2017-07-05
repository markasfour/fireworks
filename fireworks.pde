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

void setup(){
  size(640, 480);
  frameRate(60);
  projectiles = new ArrayList <projectile>();
  auto = false;
}

void draw(){
  background(0);
  
  if(auto && (frameCount % 10) == 0){
    mouseX = int(random(width * 0.15, width * 0.85));
    mousePressed();
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
}

void mousePressed(){
   projectiles.add(new projectile(mouseX));
}

void keyPressed(){
  auto = !auto; 
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
        
    void draw(){
       fill(c, a);
       ellipse(x, y, w, h);
    }
}

class projectile extends particle {
    float v;
    float acc; 
    
    projectile(){
       x = width / 2;
       y = height;
       c = #ffffff;
       a = 255;
       v = random(400, 700);
       acc = 10;
    }
    
    projectile(float X){
        x = X;
        y = height;
        c = #ffffff;
        a = 255;
        v = random(400, 700);
        acc = 10;
    }
    
    boolean isFlame(){ return false;}
    
    void move(){
      y -= v / frameRate;
      v -= acc;
    }
    
    boolean isAlive(){
       if (v >= 0)
         return true;
       return false;
    }
}

class flame extends projectile {
    float angle;
  
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