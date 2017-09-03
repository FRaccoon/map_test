
class L { // Line
  P f, t;
  
  L(P f, P t) {
    this.f = f;
    this.t = t;
  }
  
  void draw(Main m, int i) {
    this.f.draw(m, i);
    this.t.draw(m, i);
    line(this.f.x*m.scl, this.f.y*m.scl, this.t.x*m.scl, this.t.y*m.scl);
  }
  
  String str() {
    return this.f.str()+" "+this.t.str();
  }
  
  String str2() {
    return "("+this.f.str2()+", "+this.t.str2()+")";
  }
  
}

class P2 extends P { // Point
  int d;
  
  P2(float x, float y, int d) {
    super(x, y);
    this.d = d;
  }
  
  void draw(Main m, int i) {
    super.draw(m, i);
    line(this.x*m.scl, this.y*m.scl, this.x*m.scl+2*P.l*m.dx[d], this.y*m.scl+2*P.l*m.dy[d]);
  }
  
  String str() {
    return super.str()+" "+this.d;
  }
  
  String str2() {
    return super.str2();
  }
  
}

class P {
  static final int l = 6;
  float x, y;
  
  P(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  void set(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  P copy() {
    return new P(this.x, this.y);
  }
  
  void draw(Main m, int i) {
    ellipse(this.x*m.scl, this.y*m.scl, P.l, P.l);
    text(i, this.x*m.scl+P.l/2, this.y*m.scl-P.l/2);
  }
  
  String str() {
    return this.x+" "+this.y;
  }
  
  String str2() {
    return "("+this.x+", "+this.y+")";
  }
  
  String str3(Main m) {
    return "{ \"x\" : "+this.x+", \"y\" : "+(m.h()-this.y)+" }";
  }
  
}