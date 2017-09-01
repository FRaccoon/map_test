
//gr.debug = false
const Vec2 = gr.lib.math.Vector2, Vec3 = gr.lib.math.Vector3, Quat = gr.lib.math.Quaternion

document.addEventListener('DOMContentLoaded', async function() {
  
  gr(() => {
    gr('#map')('.coordinate').setAttribute('transparent', false)
    gr('#map')('.coordinate').setAttribute('enabled', gr.debug)
  })
  
  const md = await loadJSON('./data/md.json')
  let fd = new Object
  for(let f of md['floors']) {
    const d = await loadJSON(f['src'])
    fd[f['id']] = d
  }
  
  const map = new Map('#map', md, fd)
  
  var par = (() => {
    let arg = new Object
    const pair = location.search.substring(1).split('&')
    for(var i=0;pair[i];i++) {
      const kv = pair[i].split('=')
      arg[kv[0]] = kv[1]
    }
    return arg
  })()
  
  const floor = ('floor' in par ? par['floor'] : 0), from = ('from' in par ? par['from'] : 0), to = ('to' in par ? par['to'] : 0)
  
  map.init()
  map.draw_route(floor, from, to)
  
})

function loadJSON(adress) {
  return new Promise((resolve) => {
    const xhr = new XMLHttpRequest();
    xhr.addEventListener('load', () => {
      resolve(JSON.parse(xhr.responseText))
    }, false)
    xhr.open('GET', adress, true)
    xhr.send()
  })
}

class Map {
  constructor(gi, md, fd) {
    this.gi = gi
    this.md = md
    this.fd = fd
    
    this.rt = Quat.angleAxis(-Math.PI/2, new Vec3(1, 0, 0)).normalize()
    
  }
  
  init() {
    gr(() => {
      for(let i in this.fd)
        gr(this.gi)('scene').addChildByName('mesh', { geometry : 'plane', position: this.fd[i]['pos'], rotation : this.rt, texture : this.fd[i]['src'], class : 'map', transparent : true, } )
    })
  }
  
  get_vtx(fl, f, t) {
    const rs = this.fd[fl]['route']
    for(let i in rs) {
      if( (rs[i]['from']==f && rs[i]['to']==t) || 
        (rs[i]['to']==f && rs[i]['from']==t) )
        return rs[i]['vtx']
    }
    return [[0, 0]]
  }
  
  draw_line(p, q, z) {
    const r = Vec2.subtract(q, p)
    const a = Vec2.angle(new Vec2(1, 0), r)
    const s = Quat.multiply( this.rt, Quat.angleAxis( a, new Vec3(0, 0, 1))).normalize()
    
    gr(() => {
      gr(this.gi)('scene').addChildByName('mesh', { geometry : 'cube', position: [p.X+q.X-1, z, p.Y+q.Y-1], scale : [r.magnitude+0.02, 0.02, 0.02], rotation : s, color : 'red', class : 'route', transparent : false, } )
    })
  }
  
  draw_lines(vtx, z) {
    let p = new Vec2(vtx[0][0], vtx[0][1])
    for(let i=1;i<vtx.length;i++) {
      const q = new Vec2(vtx[i][0], vtx[i][1])
      this.draw_line(p, q, z)
      p = q
    }
  }
  
  draw_route(fl, f, t) {
    this.draw_lines(this.get_vtx(fl, f, t), this.fd[fl]['pos'][1])
  }
  
}


