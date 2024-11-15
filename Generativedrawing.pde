PImage img;
float rotation = 0;
boolean drawAlbert = false;  // Flag to track if we should draw Albert

void setup() {
  size(600, 600);
  background(220);
  noFill();
  
  img = loadImage("Albertsmall.png");
  img.resize(width,height);

  drawGenerative();  // Initial generative drawing
}

void draw() {
  if (drawAlbert) {
    image(img, 0, 0);  // Draw Albert
    drawAlbert = false;  // Reset flag
  }
}

void keyPressed() {
  if (key == 'd' || key == 'D') {
    drawAlbert = true;  // Set flag to draw Albert
  }
  if (key == 'r' || key == 'R') {
    background(220);    // Clear the canvas
    drawGenerative();   // Redraw generative art
  }
}

void drawGenerative() {
  float x = width / 2;
  float y = height / 2;
  
  for (int i = 0; i < 1000; i++) {
    color c = img.get(int(x), int(y));
    stroke(c, 100);

    float brightness = brightness(c);
    float stepX = map(brightness, 0, 255, -5, 5);
    float stepY = map(brightness, 0, 255, -5, 5);

    stepX += random(-2, 2);
    stepY += random(-2, 2);
    
    float size = map(brightness, 0, 255, 2, 15);
    
    pushMatrix();
    translate(x, y);
    rotate(rotation);
    
    beginShape();
    vertex(-size, -size);
    vertex(size, -size);
    vertex(size, size);
    vertex(-size, size);
    endShape(CLOSE);
    
    popMatrix();

    x += stepX;
    y += stepY;

    x = constrain(x, 0, width-1);
    y = constrain(y, 0, height-1);
    
    rotation += map(brightness, 0, 255, 0, 0.1);
  }
}
