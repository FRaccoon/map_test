
window.onload = async function() {
  var cs = document.getElementById('map')
  var ctx = cs.getContext('2d')
  
  await draw_map(cs, ctx, './map.png')
  draw_route(cs, ctx, [[.17, .25], [.20, .25], [.20, .50], [.46, .50], [.46, .56]])
  
}

function draw_map(cs, ctx, img_src) {
  return new Promise((resolve) => {
    var map_img = new Image()
    map_img.src = img_src
    map_img.onload = () => {
      ctx.drawImage(map_img, 0, 0, cs.width, cs.height)
      resolve()
    }
  })
}

function draw_route(cs, ctx, route) {
  ctx.strokeStyle = 'rgb(255, 0, 0)'
  ctx.beginPath()
  ctx.moveTo(route[0][0]*cs.width, route[0][1]*cs.height)
  for(var i=0;i<route.length;i++) {
    ctx.lineTo(route[i][0]*cs.width, route[i][1]*cs.height)
  }
  ctx.stroke()
}

