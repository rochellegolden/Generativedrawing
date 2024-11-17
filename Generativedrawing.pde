PImage img;
float rotation = 0;
boolean drawAlbert = false;

int numPaths = 5;
float[] xPos;
float[] yPos;
float[] rotations;
float[] scales;      // Added for varying sizes
int[] shapeTypes;    // Track shape type for each path

void setup() {
  size(600, 600);
  background(220);
  noFill();
  
  img = loadImage("Albertsmall.png");
  img.resize(width, height);
  
  // Initialize arrays
  xPos = new float[numPaths];
  yPos = new float[numPaths];
  rotations = new float[numPaths];
  scales = new float[numPaths];
  shapeTypes = new int[numPaths];
  
  resetPaths();
  drawGenerative();
}

void resetPaths() {
  for (int i = 0; i < numPaths; i++) {
    xPos[i] = width/2;
    yPos[i] = height/2;
    rotations[i] = random(TWO_PI);
    scales[i] = random(0.5, 1.5);
    shapeTypes[i] = int(random(6)); // Now supporting 6 different shape types
  }
}

void draw() {
  if (drawAlbert) {
    image(img, 0, 0);
    drawAlbert = false;
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    drawAlbert = true;
  }
  if (key == 'd' || key == 'D') {
    background(220);
    resetPaths();
    drawGenerative();
  }
}

void drawGenerative() {
  for (int i = 0; i < 1000; i++) {
    for (int p = 0; p < numPaths; p++) {
      color c = img.get(int(xPos[p]), int(yPos[p]));
      float alpha = map(brightness(c), 0, 255, 150, 50);
      stroke(c, alpha);
      
      float brightness = brightness(c);
      float stepX = map(brightness, 0, 255, -5, 5);
      float stepY = map(brightness, 0, 255, -5, 5);

      stepX += random(-2, 2) * (p + 1) * 0.2;
      stepY += random(-2, 2) * (p + 1) * 0.2;
      
      float size = map(brightness, 0, 255, 2, 15) * scales[p];
      
      pushMatrix();
      translate(xPos[p], yPos[p]);
      rotate(rotations[p]);
      
      // Enhanced shape variations
      drawComplexShape(p, size, brightness);
      
      popMatrix();

      xPos[p] += stepX;
      yPos[p] += stepY;
      xPos[p] = constrain(xPos[p], 0, width-1);
      yPos[p] = constrain(yPos[p], 0, height-1);
      
      rotations[p] += map(brightness, 0, 255, 0, 0.1);
    }
  }
}

void drawComplexShape(int pathIndex, float size, float brightness) {
  switch(shapeTypes[pathIndex]) {
    case 0:
      // Spiral Square
      for (int i = 0; i < 4; i++) {
        float spiralSize = size * (1 - i * 0.2);
        pushMatrix();
        rotate(i * PI/6);
        beginShape();
        vertex(-spiralSize, -spiralSize);
        vertex(spiralSize, -spiralSize);
        vertex(spiralSize, spiralSize);
        vertex(-spiralSize, spiralSize);
        endShape(CLOSE);
        popMatrix();
      }
      break;
      
    case 1:
      // Flower Pattern
      int petals = 6;
      for (int i = 0; i < petals; i++) {
        pushMatrix();
        rotate(TWO_PI * i / petals);
        ellipse(size/2, 0, size, size/2);
        popMatrix();
      }
      break;
      
    case 2:
      // Star Pattern
      beginShape();
      for (int i = 0; i < 10; i++) {
        float rad = (i % 2 == 0) ? size : size/2;
        float angle = TWO_PI * i / 10;
        vertex(cos(angle) * rad, sin(angle) * rad);
      }
      endShape(CLOSE);
      break;
      
    case 3:
      // Recursive Circles
      for (int i = 3; i > 0; i--) {
        float circleSize = size * i/2;
        ellipse(0, 0, circleSize, circleSize);
        rotate(PI/8);
      }
      break;
      
    case 4:
      // Sacred Geometry Pattern
      for (int i = 0; i < 6; i++) {
        pushMatrix();
        rotate(TWO_PI * i / 6);
        line(0, 0, size, 0);
        ellipse(size/2, 0, size/4, size/4);
        popMatrix();
      }
      break;
      
    case 5:
      // Dynamic Wave Pattern
      beginShape();
      for (int i = 0; i < 12; i++) {
        float angle = TWO_PI * i / 12;
        float rad = size + sin(angle * 3 + brightness/50) * size/3;
        vertex(cos(angle) * rad, sin(angle) * rad);
      }
      endShape(CLOSE);
      break;
  }
}
