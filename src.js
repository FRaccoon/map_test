
window.onload = function() {
  var cs = document.getElementById('map');
  var ctx = cs.getContext('2d');
  
  draw_map(cs, ctx, './map.png', [[.17, .25], [.20, .25], [.20, .50], [.46, .50], [.46, .56]]);
  
};

var draw_map = function(cs, ctx, img_src, route) {
  var map_img = new Image();
  map_img.src = img_src;
  
  map_img.onload = function() {
    ctx.drawImage(map_img, 0, 0, cs.width, cs.height);
    draw_route(cs, ctx, route);
  };
  
};

var draw_route = function(cs, ctx, route) {
  ctx.strokeStyle = 'rgb(255, 0, 0)';
  
  ctx.beginPath();
  
  ctx.moveTo(route[0][0]*cs.width, route[0][1]*cs.height);
  for(var i=0;i<route.length;i++) {
    ctx.lineTo(route[i][0]*cs.width, route[i][1]*cs.height);
  }
  
  ctx.stroke();
};

