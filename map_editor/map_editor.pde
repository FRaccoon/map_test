
Main main;

void setup() {
  size(100, 100);
  
  main = new Main();
  
}

void draw() {
  background(255);
  
  main.update();
  main.draw();
  
}

void mousePressed() {
  main.mousePressed();
}

void mouseReleased() {
  main.mouseReleased();
}

void keyPressed() {
  main.keyPressed();
}

void keyReleased() {
  main.keyReleased();
}