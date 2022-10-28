
//Modified code from: https://processing.org/examples/koch.html
KochFractal k;

void setup() {
  size(800, 800);
  background(0);
  frameRate(1);  // Animate slowly
  k = new KochFractal();
}

void draw() {

  // Draws the snowflake!
  k.render();
  // Iterate
  k.nextLevel();
  if (k.getCount() > 5) {
    k.restart();
  }
}

class KochFractal {
  PVector start;       
  PVector end;         
  ArrayList<KochLine> lines;   // A list to keep track of all the lines
  int count;

  KochFractal() {
    start = new PVector(0, height/2);
    end = new PVector(width, height/2);
    lines = new ArrayList<KochLine>();
    restart();
  }

  void nextLevel() {
    // For every line that is in the arraylist
    // create 4 more lines in a new arraylist
    lines = iterate(lines);
    count++;
  }

  void restart() {
    count = 0;      // Reset count
    lines.clear();  // Empty the array list
    lines.add(new KochLine(start, end));  // Add the initial line (from one end PVector to the other)
  }

  int getCount() {
    return count;
  }

  // This is easy, just draw all the lines
  void render() {
    for (KochLine l : lines) {
      l.display();
    }
  }

  // Step 1: Create an empty arraylist
  // Step 2: For every line currently in the arraylist
  //   - calculate 4 line segments based on Koch algorithm
  //   - add all 4 line segments into the new arraylist
  // Step 3: Return the new arraylist and it becomes the list of line segments for the structure

  // As we do this over and over again, each line gets broken into 4 lines, which gets broken into 4 lines, and so on. . .
  ArrayList iterate(ArrayList<KochLine> before) {
    ArrayList now = new ArrayList<KochLine>();    // Create emtpy list
    for (KochLine l : before) {
      // Calculate 3 koch PVectors (done for us by the line object)
      PVector b = l.kochleft();
      PVector c = l.kochmiddle();
      PVector d = l.kochright();
      // Make line segments between all the PVectors and add them
      now.add(new KochLine(b, c));
      now.add(new KochLine(c, d));
      now.add(new KochLine(d, b));
    }
    return now;
  }
}

class KochLine {

  // Two PVectors,
  // a is the "left" PVector and
  // b is the "right PVector
  PVector a;
  PVector b;

  KochLine(PVector start, PVector end) {
    a = start.copy();
    b = end.copy();
  }

  void display() {
    stroke(255);
    if (a.x > 0) {
      line(a.x, a.y, b.x, b.y);
    }
  }

  PVector start() {
    return a.copy();
  }

  PVector end() {
    return b.copy();
  }

  PVector kochleft() {
    PVector v = PVector.sub(b, a);
    v.div(3);
    v.add(a);
    return v;
  }

  PVector kochmiddle() {
    PVector v = PVector.sub(b, a);
    v.div(3);

    PVector p = a.copy();
    p.add(v);

    v.rotate(-radians(60));
    p.add(v);

    return p;
  }

  PVector kochright() {
    PVector v = PVector.sub(a, b);
    v.div(3);
    v.add(b);
    return v;
  }
}
