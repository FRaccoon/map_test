
gr.debug = false
const Vec2 = gr.lib.math.Vector2, Vec3 = gr.lib.math.Vector3, Quat = gr.lib.math.Quaternion

document.addEventListener('DOMContentLoaded', async function() {
  
  const goml_id = '#map'
  
  gr(() => {
    gr(goml_id)('#coordinate').setAttribute('enabled', gr.debug)
    gr(goml_id)('#coordinate').setAttribute('transparent', false)
  })
  
  const loadJSON = (adress) => {
    return new Promise((resolve) => {
      const xhr = new XMLHttpRequest();
      xhr.addEventListener('load', () => {
        resolve(JSON.parse(xhr.responseText))
      }, false)
      xhr.open('GET', adress, true)
      xhr.send()
    })
  }
  
  const md = await loadJSON('./data/md.json')
  let fd = new Object
  for(let f of md.floors) {
    const d = await loadJSON(f.src)
    fd[f['id']] = d
  }
  
  const map = new Map(gr(goml_id)('#world'), md, fd)
  
  var par = (() => {
    let arg = new Object
    const pair = location.search.substring(1).split('&')
    for(var i=0;pair[i];i++) {
      const kv = pair[i].split('=')
      arg[kv[0]] = kv[1]
    }
    return arg
  })()
  
  const ff = ('ff' in par ? par.ff : 0), fi = ('fi' in par ? par.fi : 0)
  const tf = ('tf' in par ? par.tf : 0), ti = ('ti' in par ? par.ti : 0)
  
  map.init()
  
  map.draw_route(ff, fi, tf, ti)
  
})

class Map {
  
  constructor(world, md, fd) {
    this.world = world
    this.md = md
    this.fd = fd  
  }
  
  init() {
    gr(() => {
      for(let i in this.fd) {
        const f = this.fd[i]
        const pos = f.pos, sz = f.size
        this.world.addChildByName('mesh', { geometry : 'plane', position : [ pos.x, pos.y, pos.z ], texture : f.src, scale : [sz.x/2, sz.y/2, 1], class : 'map', transparent : true, } )
        for(let j in f.booth) {
          this.world.addChildByName('mesh', {geometry : 'point', position : this.get_pos(i, f.booth[j].pos), scale : .01, class : 'map', color : 'green', transparent : false, } )
        }
      }
      
      this.world.setAttribute('rotation', '-90, 0, 0')
    })
  }
  
  get_vtx(fl, f, t) {
    const rs = this.fd[fl].route
    for(let i in rs) {
      const r = rs[i]
      if(r.from==f && r.to==t)return r.vtx
      else if(r.to==f && r.from==t)return r.vtx.concat().reverse()
    }
    return [{x:0, y:0}]
  }
  
  get_pos(fl, p) {
    const pos = this.fd[fl].pos, sz = this.fd[fl].size
    return new Vec3( pos.x+p.x-sz.x/2, pos.y+p.y-sz.y/2, pos.z )
  }
  
  get_vtx_pos(fl, vtx) {
    let r = []
    for(let i=0;i<vtx.length;i++)r.push(this.get_pos(fl, vtx[i]))
    return r
  }
  
  get_route(ff, fi, tf, ti) {
    if(ff==tf)return this.get_vtx_pos(ff, this.get_vtx(ff, fi, ti))
    else return this.get_vtx_pos( ff, this.get_vtx(ff, fi, 0) ).concat( this.get_vtx_pos( tf, this.get_vtx(tf, 0, ti) ) )
  }
  
  draw_line(p, q) {
    const r = Vec3.subtract(q, p)
    const s = Quat.fromToRotation(Vec3.XUnit, r).normalize()
    gr(() => {
      this.world.addChildByName('mesh', { geometry : 'cube', position : Vec3.multiply(.5, Vec3.add(p, q)), scale : [r.magnitude/2+.01, .01, .01], rotation : s, color : 'red', class : 'route', transparent : false, })
    })
  }
  
  draw_lines(pos) {
    let p = pos[0]
    for(let i=1;i<pos.length;i++) {
      const q = pos[i]
      this.draw_line(p, q)
      p = q
    }
  }
  
  draw_route(ff, fi, tf, ti) {
    this.draw_lines(this.get_route(ff, fi, tf, ti))
  }
  
}


