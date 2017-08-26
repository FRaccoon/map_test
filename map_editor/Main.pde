
class Main {
  
  String src;
  PImage map;
  
  float w, h;
  
  int[] dx = {1, 0,-1, 0};
  int[] dy = {0, 1, 0,-1};
  
  int st; // state
  boolean d; // debug
  
  int pd; // point_direction
  int ld; // line_direction
  
  boolean pm, ms; // prev_mouse, mouse_state
  
  ArrayList<P> ps;
  int pn;
  
  ArrayList<L> ls;
  int ln;
  P fp;
  
  Main() {
    
    src = "./map_image.png";
    this.load_image();
    
    this.w = width;
    this.h = height;
    
    this.ps = new ArrayList<P>();
    this.pn = 0;
    
    this.ls = new ArrayList<L>();
    this.ln = 0;
    
    fp = new P(0, 0, 0);
    
    this.st = 0;
    this.d = true;
    
    this.pd = 0;
    this.pd = 0;
    
    this.pm = false;
    this.ms = false;
    
  }
  
  void load_image() {
    map = loadImage(src);
    if(this.d)println("load "+src+".");
  }
  
  void add_p(P p) {
    this.ps.add(p);
    this.pn++;
    if(this.d)println("add point "+p.str2(true)+".");
  }
  
  P get_p(int i) {
    if(0<=i && i<this.pn)return ps.get(i);
    else return null;
  }
  
  void rm_p() {
    if(this.pn>0) {
      this.ps.remove(this.pn-1);
      this.pn--;
      if(this.d)println("remov point.");
    }else if(this.d)println("no point.");
  }
  
  void add_l(L l) {
    this.ls.add(l);
    this.ln++;
    if(this.d)println("add line"+l.str2()+".");
  }
  
  L get_l(int i) {
    if(0<=i && i<this.ln)return ls.get(i);
    else return null;
  }
  
  void rm_l() {
    if(this.ln>0) {
      this.ls.remove(this.ln-1);
      this.ln--;
      if(this.d)println("remov line.");
    }else if(this.d)println("no line.");
  }
  
  void update() {
    if(!this.pm && this.ms)this.mousePushed();
    this.pm = this.ms;
  }
  
  void draw() {
    image(this.map, 0, 0, this.w, this.h);
    
    stroke(255, 0, 0);
    fill(255, 0, 0);
    for(int i=0;i<this.pn;i++)this.get_p(i).draw(this, true);
    
    stroke(0, 0, 255);
    fill(0, 0, 255);
    for(int i=0;i<this.ln;i++)this.get_l(i).draw(this);
    if(this.st==1 && this.ms)line(fp.x*this.w, fp.y*this.h, (this.ld==1?fp.x*this.w:mouseX), (this.ld==2?fp.y*this.h:mouseY));
    
  }
  
  void mousePushed() {
    if(this.st==1)fp.set(mouseX/this.w, mouseY/this.h);
  }
  
  void mousePressed() {
    this.ms = true;
  }
  
  void mouseReleased() {
    float mx = mouseX/this.w, my = mouseY/this.h;
    switch(this.st) {
      case 0:
        this.add_p(new P(mx, my, this.pd));
      break;
      case 1:
        this.add_l( new L( fp.copy(), new P((this.ld==1?fp.x:mx), (this.ld==2?fp.y:my), 0) ) );
    }
    this.ms = false;
  }
  
  void keyPressed() {}
  
  void keyReleased() {
    switch(key) {
      case 'd':
        this.c_dir();
      break;
      case 'r':
        this.rm_data();
      break;
      case 't':
        this.toggle();
      break;
      case 's':
        this.save_txt();
      break;
      case 'S':
        this.save_json();
      break;
      case 'l':
        this.load();
      break;
    }
  }
  
  void rm_data() {
    if(this.st==0)this.rm_p();
    else if(this.st==1)this.rm_l();
  }
  
  void c_dir() {
    switch(this.st) {
      case 0:
        this.pd = (this.pd+1)%4;
        if(this.d)println("change point direction to ("+this.dx[this.pd]+", "+this.dy[this.pd]+").");
      break;
      case 1:
        this.ld = (this.ld+1)%3;
        if(this.d)println("change line direction to "+(this.ld==0?"free":(this.ld==1?"tate":"yoko"))+".");
      break;
    }
  }
  
  void toggle() {
    this.st = (this.st+1)%2;
    if(this.d)println("toggle to "+(this.st==0?"point":"line")+" mode.");
  }
  
  void save_txt() {
    String[] str = new String[this.pn+this.ln+2];
    int t = 0;
    
    str[0] = this.ln+"";
    t++;
    for(int i=0;i<this.ln;i++) {
      str[t] = this.get_l(i).str();
      t++;
    }
    
    str[t] = this.pn+"";
    t++;
    for(int i=0;i<this.pn;i++) {
      str[t] = this.get_p(i).str(true);
      t++;
    }
    
    saveStrings("./map_data.txt", str);
    if(this.d)println("save text_data.");
  }
  
  void save_json() {
    String[] str = new String[this.pn+5];
    int t=0;
    
    str[0] = "{";
    str[1] = "  \"src\" : \""+src+"\",";
    str[2] = "  \"points\" : [";
    
    t = 3;
    
    for(int i=0;i<ps.size();i++) {
      str[t] = "    { \"id\" : "+i+", \"pos\" : "+this.get_p(i).str2(false)+", \"about\" : \"aaa\"}"+(i<this.pn-1?",":"");
      t++;
    }
    
    str[t] = "  ],";
    t++;
    str[t] = "}";
    
    saveStrings("../map_data.json", str);
    if(this.d)println("save json_data.");
  }
  
  void load() {
    String str[] = loadStrings("./map_data.txt");
    
    int l = int(str[0]);
    for(int i=0;i<l;i++) {
      String[] dt = split(str[i+1], " ");
      this.add_l( new L( new P(float(dt[0]), float(dt[1]), 0), new P(float(dt[2]), float(dt[3]), 0) ) );
    }
    
    int p = int(str[l+1]);
    for(int i=0;i<p;i++) {
      String[] dt = split(str[i+l+2], " ");
      this.add_p( new P(float(dt[0]), float(dt[1]), int(dt[2])) );
    }
    
    if(this.d)println("data load.");
  }
}

class L { // Line
  P f, t;
  
  L(P f, P t) {
    this.f = f;
    this.t = t;
  }
  
  void draw(Main m) {
    this.f.draw(m, false);
    this.t.draw(m, false);
    line(this.f.x*m.w, this.f.y*m.h, this.t.x*m.w, this.t.y*m.h);
  }
  
  String str() {
    return this.f.str(false)+" "+this.t.str(false);
  }
  
  String str2() {
    return "("+this.f.str2(true)+", "+this.t.str2(true)+")";
  }
  
}

class P { // Point
  float x, y;
  int d;
  
  P(float x, float y, int d) {
    this.x = x;
    this.y = y;
    this.d = d;
  }
  
  void set(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  P copy() {
    return new P(this.x, this.y, 0);
  }
  
  void draw(Main m, boolean b) {
    int l = 6;
    ellipse(this.x*m.w, this.y*m.h, l, l);
    if(b)line(this.x*m.w, this.y*m.h, this.x*m.w+2*l*m.dx[d], this.y*m.h+2*l*m.dy[d]);
  }
  
  String str(boolean b) {
    return this.x+" "+this.y+(b?" "+this.d:"");
  }
  
  String str2(boolean b) {
    if(b)return "("+this.x+", "+this.y+")";
    else return "["+this.x+", "+this.y+"]";
  }
  
}