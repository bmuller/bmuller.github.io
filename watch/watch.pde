int fwidth = 60;
color bground = #000000;
int padding = 40; 

void setup() {
  size(700, 700);
  noStroke();
  background(bground);
}

void timeNut(float numerator, float denominator, int offset, color fillc, boolean units) {
  float percent = numerator / denominator;
  fill(fillc);
  int size = ((offset + 1) * fwidth);
  arc(width / 2, height / 2, size + 1, size + 1, 0 - HALF_PI, percent * TWO_PI - HALF_PI); //, PIE);

  if (units) {
    float increment = TWO_PI / denominator;
    int diff = 0;
    float thinkness = (4 - offset) / 100.0;
    for (int i = 1; i < numerator; i++) {       
      fill(bground);
      float rads = 0 - HALF_PI + (increment * i);
      arc(width / 2, height / 2, size + 1, size + 1, rads - (thinkness / 2), rads + (thinkness / 2)); //, PIE);
    }
  }

  fill(bground);
  arc(width / 2, height / 2, size - fwidth + padding, size - fwidth + padding, 0 - HALF_PI, (percent + 0.01) * TWO_PI - HALF_PI); //, PIE);
}

void draw() {
  float millis = (new Date()).getMilliseconds();

  float[] numerators = {
    month() + (day() / 31.0), day() + (hour() / 23.0), hour() + (minute() / 60.0), minute() + (second() / 60.0), second() + (millis / 1000.0), millis
  };  
  float[] denominators = {
    12.0, 31.0, 24.0, 60.0, 60.0, 1000.0
  }; 

  color[] fills = { 
    #C2662D, #F9F4D6, #C59D57, #70979E, #71747D, #402A1F
  };

  background(#000000);
  for (int i=numerators.length; i > 0; i--)
    timeNut(numerators[i-1], denominators[i-1], i, fills[(i-1) % fills.length], i < (numerators.length - 1));
}

