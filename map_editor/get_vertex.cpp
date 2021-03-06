#include <bits/stdc++.h>

using namespace std;

typedef long long ll;
typedef unsigned long long ull;
typedef double R; //double long double の切り替え cmathの関数はオーバーロードに対応しているので問題ない
typedef complex<R> Point;
typedef pair<Point , Point> Line;
typedef pair<Point ,R > Circle;
typedef vector<Point> Poly;

#define EPS (1e-2) //誤差
#define EQ(a,b) (abs((a)-(b)) < EPS) //２つの実数が等しいか
#define EQV(a,b) ( EQ((a).real(), (b).real()) && EQ((a).imag(), (b).imag()) ) //２つのベクトルが等しいか
#define ft first
#define sd second
#define pb push_back

#define sz(v) (int)v.size()

R dx[]={ 1.0, 0.0,-1.0, 0.0};
R dy[]={ 0.0, 1.0, 0.0,-1.0};
 
R dot(Point a,Point b){ //内積ok
    return (a.real() * b.real() + a.imag() * b.imag());
}
R cross(Point a,Point b){ //外積ok
    return (a.real() * b.imag() - a.imag() * b.real());
}

bool is_orthogonal(Line a,Line b){ //2直線の直行判定ok
    return EQ(dot(a.ft - a.sd,b.ft - b.sd),0.0);
}
bool is_parallel(Line a,Line b){ //2直線の並行判定ok
    return EQ(cross(a.ft - a.sd,b.ft - b.sd),0.0);
}

////////////////////交差判定
int ccw(Point a,Point b,Point c){ //ok
    b -= a; c -= a;
    if(cross(b,c) > EPS) return 1; //a→bで反時計周りに折れてb→c
    if(cross(b,c) < -EPS) return -1; //a→bで時計周りに折れてb→c
    if(dot(b,c) < -EPS) return 2; //c--a--b on same line
    if(norm(c) - norm(b) > EPS) return -2; //a--b--c(absじゃなくて二乗するのは差が出やすいから?)
    return 0; //a--c--bまたはb==c
}

bool is_intersection_ss(Line a,Line b){ //２つの線分が交わるかok
    return ccw(a.ft,a.sd,b.ft)*ccw(a.ft,a.sd,b.sd) <= 0 && ccw(b.ft,b.sd,a.ft)*ccw(b.ft,b.sd,a.sd) <= 0;
}

Point intersection_ll(Line l,Line m){ //交差判定してるなら線分にも使えるok
    R A = cross(l.sd - l.ft,m.sd - m.ft);
    R B = cross(l.sd - l.ft,l.sd - m.ft);
    if(abs(A) < EPS && abs(B) < EPS) return m.ft; //同じ線
    if(abs(A) < EPS)assert(false); //並行で交点なし
    return m.ft + B / A * (m.sd - m.ft);
}

R dis_lp(Line l,Point p){ //直線lと点pの距離ok
    return abs(cross(l.sd - l.ft,p - l.ft)) / abs(l.sd - l.ft);
}

int get_near_s(vector<Line> s,Line p){
    double mind;
    int si = -1;
    for(int i=0; i<sz(s); i++){
        if( is_intersection_ss(s[i], p) && (si == -1 || dis_lp(s[i], p.ft) < mind) ){
            mind = dis_lp(s[i],p.ft);
            si = i;
        }
    }
    return si;
}

struct rt_data{
    vector<Point> p;
    double dis;
};

rt_data get_rt(const vector<Line> s, int start_l, Point start_p, int goal_l, Point goal_p, ll mask){
    rt_data ret;
    if(start_l == goal_l){
        if( !EQV(start_p, goal_p) ) {
            ret.p.pb(start_p);
            ret.p.pb(goal_p);
        }
        ret.dis = abs(start_p - goal_p);
        return ret;
    }

    ret.p.pb(start_p);
    ret.dis = DBL_MAX;

    for(int i=0; i<sz(s); i++){
        if( (1 << i & mask) || !is_intersection_ss(s[i], s[start_l]) )
            continue;
        rt_data rt = get_rt( s, i, intersection_ll(s[i], s[start_l]), goal_l, goal_p, 1<<i | mask );
        if( rt.dis < ret.dis ){
            for(int j=0; j<sz(rt.p); j++)
                ret.p.pb(rt.p[j]);
            ret.dis = rt.dis;
        }
    }
    return ret;
}

int main(){
    int n;
    double w, h;
    double x, y, x_, y_;
    
    vector<Line> s, p;
    vector<int> near_s;
    vector<Point> ps;
    
    cin>>w>>h;
    cin >> n; //point
    for(int i=0; i<n; i++){
        int d;
        cin >> x >> y >> d;
        x_ = x + w*dx[d];
        y_ = y + h*dy[d];
        p.pb( Line( Point(x, y) , Point(x_, y_) ) );
        ps.pb(Point(x,y));
    }
    
    cin >> n; //line
    for(int i=0; i<n; i++){
        cin >> x >> y >> x_ >> y_;
        s.pb( Line( Point(x, y) , Point(x_, y_) ) );
    }
     
    for(int i=0;i < sz(p); i++){
        near_s.pb( get_near_s(s, p[i]) );
        if( near_s[i] == -1 ){
            cout << "  error! " << i << " 番目の部屋から出れない" << endl;
            return 0;
        }
    }
    
    cout << "  \"route\" : [";
    
    for(int i=0; i<sz(p); i++){
        for(int j=i; j<sz(p); j++){
            rt_data rt;
            rt.p.pb(p[i].ft);
            
            if(i!=j) {
                rt_data totu = get_rt( s, near_s[i], intersection_ll(s[near_s[i]], p[i]), near_s[j], intersection_ll(s[near_s[j]], p[j]), 1<<near_s[i] );
                
                for(int k=0; k<sz(totu.p); k++)
                    rt.p.pb(totu.p[k]);
                rt.p.pb(p[j].ft);
                
                rt.dis = dis_lp(s[near_s[i]], p[i].ft) + totu.dis + dis_lp(s[near_s[j]], p[j].ft);
                
                if(rt.dis > 1000000000000.0) {
                    cout << "\n\n  error!   " << i << "から" << j << "へ" << "たどり着けない" << endl;
                    return 0;
                }

            }
            
            cout << "\n    { \"from\" : " << i << " , \"to\" : " << j << " , \"vtx\" : [";
            for(int k=0; k<sz(rt.p); k++){
                //cout << " { \"x\" : " << rt.p[k].real() << ", \"y\" : " << h-rt.p[k].imag() << " } "<<( k<sz(rt.p)-1 ? "," : "] }" );
                int id = -1;
                for(int l = 0;l<sz(ps);l++){
                    if(EQV(rt.p[k],ps[l])){
                        id = l;
                        break;
                    }
                }
                if(id == -1){
                    ps.pb(rt.p[k]);
                    id = (int)ps.size() - 1;
                }
                cout << id <<( k<sz(rt.p)-1 ? "," : "] }" );
            }
            
            cout<<( i==sz(p)-1 ? "\n  ]," : "," );
        }
    }
    
    cout << endl;
    cout << "  \"points\" : [\n";
    for(int i = 0;i < sz(ps);i++){
        cout << "    { \"id\" : " << i << ", \"x\" : " << ps[i].real() << ", \"y\" : " << h - ps[i].imag() << "}" << ((i == sz(ps) - 1) ? "\n  ]" : ",\n");
    }
    
    return 0;
}

