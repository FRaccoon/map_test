
class Main {
  
  String src;
  PImage map;
  float scl;
  
  int[] dx = {1, 0,-1, 0};
  int[] dy = {0, 1, 0,-1};
  
  int st; // state
  boolean d = true; // debug
  
  int pd; // point_direction
  int ld; // line_direction
  
  boolean pm, ms; // prev_mouse, mouse_state
  
  ArrayList<P2> ps;
  int pn;
  
  ArrayList<L> ls;
  int ln;
  P fp;
  
  ArrayList<P> bs; // booth
  int bn;
  
  String inp;
  
  Main() {
    
    this.scl = 100;
    
    src = "./data/img.png";
    this.load_image();
    
    this.ps = new ArrayList<P2>();
    this.pn = 0;
    
    this.ls = new ArrayList<L>();
    this.ln = 0;
    
    fp = new P(0, 0);
    
    this.bs = new ArrayList<P>();
    this.bn = 0;
    
    this.st = 0;
    
    this.pd = 0;
    this.ld = 0;
    
    this.pm = false;
    this.ms = false;
    
    inp="";
    
  }
  
  void load_image() {
    this.map = loadImage("../"+src);
    
    surface.setResizable(true);
    surface.setSize(this.map.width, this.map.height);
    surface.setResizable(false);
    
    this.db("load "+src+" "+this.w()+"x"+this.h()+".");
  }
  
  float w() {
    return this.map.width/this.scl;
  }
  
  float h() {
    return this.map.height/this.scl;
  }
  
  void add_p(P2 p) {
    this.ps.add(p);
    this.pn++;
    this.db("add point "+this.pn+" at "+p.str2()+".");
  }
  
  P2 get_p(int i) {
    if(0<=i && i<this.pn)return ps.get(i);
    else return null;
  }
  
  void rm_p(int i) {
    if(0<i && i<=this.pn) {
      this.ps.remove(i-1);
      this.pn--;
      this.db("remove point "+i+".");
    }else this.db("no point.");
  }
  
  void add_b(P b) {
    this.bs.add(b);
    this.bn++;
    this.db("add booth "+this.bn+" at "+b.str2()+".");
  }
  
  P get_b(int i) {
    if(0<=i && i<this.bn)return bs.get(i);
    else return null;
  }
  
  void rm_b(int i) {
    if(0<i && i<=this.bn) {
      this.bs.remove(i-1);
      this.bn--;
      this.db("remove booth "+i+".");
    }else this.db("no booth.");
  }
  
  void add_l(L l) {
    this.ls.add(l);
    this.ln++;
    this.db("add line"+this.ln+" at "+l.str2()+".");
  }
  
  L get_l(int i) {
    if(0<=i && i<this.ln)return ls.get(i);
    else return null;
  }
  
  void rm_l(int i) {
    if(0<i && i<=this.ln) {
      this.ls.remove(i-1);
      this.ln--;
      this.db("remove line "+i+".");
    }else this.db("no line.");
  }
  
  void update() {
    if(!this.pm && this.ms)this.mousePushed();
    this.pm = this.ms;
  }
  
  void draw() {
    image(this.map, 0, 0, this.map.width, this.map.height);
    
    textSize(12);
    textAlign(LEFT, BOTTOM);
    
    stroke(255, 0, 0);
    fill(255, 0, 0);
    for(int i=0;i<this.pn;i++)this.get_p(i).draw(this, i+1);
    
    stroke(0, 0, 255);
    fill(0, 0, 255);
    for(int i=0;i<this.ln;i++)this.get_l(i).draw(this, i+1);
    if(this.st==1 && this.ms)(new L(fp, new P((this.ld==1?fp.x:mouseX), (this.ld==2?fp.y:mouseY)))).draw(this, this.ln+2);
    
    stroke(0, 255, 0);
    fill(0, 255, 0);
    for(int i=0;i<this.bn;i++)this.get_b(i).draw(this, i+1);
    
  }
  
  void mousePushed() {
    if(this.st==1)fp.set(mouseX/this.scl, mouseY/this.scl);
  }
  
  void mousePressed() {
    this.ms = true;
  }
  
  void mouseReleased() {
    float mx = mouseX/this.scl, my = mouseY/this.scl;
    switch(this.st) {
      case 0:
        this.add_p(new P2(mx, my, this.pd));
      break;
      case 1:
        this.add_l( new L( fp.copy(), new P((this.ld==1?fp.x:mx), (this.ld==2?fp.y:my)) ) );
      case 2:
        this.add_b(new P(mx, my));
      break;
    }
    this.ms = false;
  }
  
  void keyPressed() {}
  
  void keyReleased() {
    boolean i = false;
    if(this.is_w(key)) {
      this.inp += key;
      i = true;
    }
    else switch(key) {
      case ENTER:
        this.cmd();
        this.inp = "";
      break;
      default:
      switch(keyCode) {
        case BACKSPACE:
          if(this.inp.length()>0) {
            this.inp = this.inp.substring(0, this.inp.length()-1);
            i = true;
          }
        break;
      }
      break;
    }
    if(i)println("> "+this.inp);
  }
  
  boolean is_w(char c) {
    if(0<=c-'a' && c-'z'<=0)return true;
    else if(0<=c-'A' && c-'Z'<=0)return true;
    else if(0<=c-'0' && c-'9'<=0)return true;
    else if(c==' ')return true;
    else return false;
    
  }
  
  void cmd() {
    String[] t = splitTokens(this.inp, " ");
    if(t.length<1) {
      this.db("no command");
    }else {
      int i = t.length<2?0:int(t[1]);
      switch(t[0].charAt(0)) {
      case 'd':this.c_dir(i);break;
      case 'r':this.rm_data(i);break;
      case 't':this.toggle(i);break;
      case 's':this.save(i);break;
      case 'l':this.load_data();break;
      default:this.db("it is not command.");break;
      }
    }
  }
  
  void rm_data(int t) {
    switch(this.st) {
      case 0:
        this.rm_p(t>0?t:this.pn);
      break;
      case 1:
        this.rm_l(t>0?t:this.ln-1);
      break;
      case 2:
        this.rm_b(t>0?t:this.bn-1);
      break;
    }
  }
  
  void c_dir(int t) {
    switch(this.st) {
      case 0:
        this.pd = (t>0?t:(this.pd+1))%4;
        this.db("change point direction to ("+this.dx[this.pd]+", "+this.dy[this.pd]+").");
      break;
      case 1:
        this.ld = (t>0?t:(this.ld+1))%3;
        this.db("change line direction to "+(this.ld==0?"free":(this.ld==1?"tate":"yoko"))+".");
      break;
    }
  }
  
  void toggle(int t) {
    this.st = (t>0?t:(this.st+1))%3;
    String cns = "";
    switch(this.st) {
      case 0:cns = "point";break;
      case 1:cns = "line";break;
      case 2:cns = "booth";break;
    }
    this.db("toggle to "+cns+" mode.");
  }
  
  void save(int t) {
    switch(t) {
      case 0:this.save_data();break;
      case 1:this.save_text();break;
      case 2:this.save_json();break;
    }
  }
  
  void save_data() {
    String[] str = new String[this.bn+this.pn+this.ln+3];
    int t = 0;
    
    str[t++] = this.pn+"";
    for(int i=0;i<this.pn;i++) {
      str[t++] = this.get_p(i).str();
    }
    
    str[t++] = this.ln+"";
    for(int i=0;i<this.ln;i++) {
      str[t++] = this.get_l(i).str();
    }
    
    str[t++] = this.bn+"";
    for(int i=0;i<this.bn;i++) {
      str[t++] = this.get_b(i).str();
    }
    
    saveStrings("./sd.txt", str);
    this.db("save data.");
  }
  
  void save_text() {
    String[] str = new String[this.pn+this.ln+3];
    int t = 0;
    
    str[t++] = this.w()+" "+this.h();
    str[t++] = this.pn+"";
    for(int i=0;i<this.pn;i++) {
      str[t++] = this.get_p(i).str();
    }
    
    str[t++] = this.ln+"";
    for(int i=0;i<this.ln;i++) {
      str[t++] = this.get_l(i).str();
    }
    
    saveStrings("./st.txt", str);
    this.db("save text data.");
  }
  
  void save_json() {
    String[] str = new String[this.bn+6];
    int t=0;
    
    str[t++] = "{";
    str[t++] = "  \"src\" : \""+src+"\",";
    str[t++] = "  \"size\" : { \"x\" : "+this.w()+", \"y\" : "+this.h()+" },";
    str[t++] = "  \"booth\" : [";
    
    for(int i=0;i<this.bn;i++) {
      str[t++] = "    { \"id\" : "+i+", \"pos\" : "+this.get_b(i).str3(this)+", \"about\" : \"aa\" }"+(i<this.bn-1?",":"");
    }
    
    str[t++] = "  ],";
    str[t] = "}";
    
    saveStrings("./sj1.json", str);
    this.db("save json data.");
  }
  
  void load_data() {
    String str[] = loadStrings("./sd.txt");
    if(str==null) {
      this.db("no load file.");
      return ;
    }
    int t=0;
    
    int p = int(str[t++]);
    for(int i=0;i<p;i++) {
      String[] dt = split(str[t++], " ");
      this.add_p( new P2(float(dt[0]), float(dt[1]), int(dt[2])) );
    }
    
    int l = int(str[t++]);
    for(int i=0;i<l;i++) {
      String[] dt = split(str[t++], " ");
      this.add_l( new L( new P(float(dt[0]), float(dt[1])), new P(float(dt[2]), float(dt[3])) ) );
    }
    
    int b = int(str[t++]);
    for(int i=0;i<b;i++) {
      String[] dt = split(str[t++], " ");
      this.add_b( new P(float(dt[0]), float(dt[1])) );
    }
    
    this.db("load data.");
  }
  
  void db(String e) {
    if(this.d)println(e);
  }
  
}