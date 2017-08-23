
 document.addEventListener("DOMContentLoaded", async function() {
  var cs = new Canvas('map')
  
  const map_data = await loadJSON('map_data.json')
  const map_image = await load_image(map_data['src'])
  cs.draw_image(map_image)
  cs.stroke('rgb(255, 0, 0)')
  var route = get_route();
  cs.draw_lines(route);
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

function loadJSON() {
  return new Promise((resolve) => {
    var xhr = new XMLHttpRequest();
    xhr.addEventListener('load', () => {
      resolve(JSON.parse(xhr.responseText))
    }, false)
    xhr.open('GET', './test_json.json', true)
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

function get_route() {
  return [[.17, .25], [.20, .25], [.20, .50], [.46, .50], [.46, .56]];
  
}

