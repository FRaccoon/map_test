
 document.addEventListener('DOMContentLoaded', async function() {
  var cs = new Canvas('map')
  
  const map_data = await loadJSON('sample_data.json')
  const map_image = await load_image(map_data['src'])
  
  cs.draw_image(map_image)
  
  var param = get_param()
  
  var from = ('from' in param ? param['from'] : 0), 
  to = ('to' in param ? param['to'] : 0)
  
  var route = get_route(map_data, from, to)
  
  cs.stroke('rgb(255, 0, 0)')
  cs.draw_lines(route)
  
})

class Canvas {
  constructor(cs_id) {
    this.cs = document.getElementById(cs_id)
    this.ctx = this.cs.getContext('2d')
    
    this.width = this.cs.width
    this.height = this.cs.height
  }
  
  stroke(color) {
    this.ctx.strokeStyle = color
  }
  
  fill(color) {
    this.ctx.fillStyle = color
  }
  
  draw_lines(vtx) {
    this.ctx.beginPath()
    this.ctx.moveTo(vtx[0][0]*this.width, vtx[0][1]*this.height)
    for(var i=0;i<vtx.length;i++) {
      this.ctx.lineTo(vtx[i][0]*this.width, vtx[i][1]*this.height)
    }
    this.ctx.stroke()
  }
  
  draw_image(img) {
    this.ctx.drawImage(img, 0, 0, this.width, this.height)
  }
  
}

function loadJSON(adress) {
  return new Promise((resolve) => {
    var xhr = new XMLHttpRequest();
    xhr.addEventListener('load', () => {
      resolve(JSON.parse(xhr.responseText))
    }, false)
    xhr.open('GET', adress, true)
    xhr.send()
  })
}

function load_image(img_src) {
  return new Promise((resolve) => {
    var img = new Image()
    img.src = img_src
    img.onload = () => {
      resolve(img)
    }
  })
}

function get_param() {
  var arg = new Object
  var pair = location.search.substring(1).split('&')
  for(var i=0;pair[i];i++) {
    var kv = pair[i].split('=')
    arg[kv[0]] = kv[1]
  }
  return arg
}

function get_route(json, from, to) {
  var routes = json['route']
  for(var i=0;i<routes.length;i++) {
    if( (routes[i]['from']==from && routes[i]['to']==to) || 
      (routes[i]['to']==from && routes[i]['from']==to) )
      return routes[i]['vtx']
  }
  return [json['points']['pos']]
}

