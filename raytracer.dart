import 'lib/lib_vecmath.dart';
import 'lib/lib_ray.dart';
import 'lib/lib_graphics.dart';
import 'dart:math';
import 'dart:html';
import 'dart:async';
import 'package:intl/intl.dart';

// globals
ImageOut out = null;
//TextureManager tm;
Scene scene = null;
Stopwatch stopwatch = new Stopwatch();

void main() 
{
  print ('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-');
  putMessage("Dart Raytracer v0.01...");
  
  out = new ImageOut('#canvas_output');
  querySelector('#but_load').onClick.listen(loadSceneFile);
  querySelector('#but_render').onClick.listen(parseAndRender);

  loadSceneFile(null);
}

/*refreshLoop(num delta) {
  out.updateCanvas();
  if(!done)
    window.animationFrame.then(refreshLoop);
}*/

loadSceneFile(Event e) {
  SelectElement scenes = querySelector('#sel_scenes');
  
  String scene_name = scenes.selectedOptions.elementAt(0).value;
  putMessage("Loading scene: " + scene_name);
  
  HttpRequest.getString('scenes/$scene_name').then(loadAndRender);
}

loadAndRender(String data) {
  (querySelector('#ta_scene') as TextAreaElement).value = data;
  
  scene = new Scene(out);
  scene.parseScene(data);
  
  Future.wait([ImageManager.loadAllImages()])
    .then((_) => render());
}

parseAndRender(Event e) {
  scene = new Scene(out);
  scene.parseScene((querySelector('#ta_scene') as TextAreaElement).value);
 
  Future.wait([ImageManager.loadAllImages()])
    .then((_) => render());
}

render() {
  print("Rendering now...");
  clearMessages();
  putMessage("Scene loaded. Contains " + scene.getAllObjects.length.toString() + " objects");
  putMessage("Rendering started...");

  stopwatch.start();
  
  for(int y = 0; y < out.height; y++) {
    for(int x = 0; x < out.width; x++) {
      // !todo! Camera code, for now - hard code camera/eye ray parameters
      Ray ray = new Ray.pointAt(new Point3D.init(0.0, 0.0, -2000.0), new Point3D.init(x - (out.width / 2), (out.height / 2) - y, 0.0));
      RGB ray_color = shadeRay(ray, x, y); 
      out.drawPixel(ray_color, x, y);
    } // end x loop
  } // end y loop
  stopwatch.stop();
  
  out.updateCanvas();
  
  num time = stopwatch.elapsedMilliseconds / 1000.0;
  putMessage("ALL DONE! Render took ${time}ms");
  int pps = ((out.width * out.height) / time).round();
  var num_f = new NumberFormat("###,###,###,###,###", "en_UK");
  putMessage("Pixels per second: ${num_f.format(pps)}");  
  putMessage("Total ${num_f.format(Ray.getRayTotal)} rays cast");  
}

RGB shadeRay(Ray ray, int x, int y) {

  double t = double.INFINITY;
  Object3D hit_obj = null;
  for(Object3D obj in scene.getAllObjects) {

    double new_t = obj.calcT(ray);
    
    if (new_t > 0.0 && new_t < t) {
      t = new_t;
      hit_obj = obj;
    }
  }
  
  // We have an object hit! Time to do more work 
  if(t > 0.0 && t < double.INFINITY) {
    Hit hit = hit_obj.calcHitDetails(t, ray);
    
    // Point3D light = new Point3D.init(-1550.0, -433.0, -400.0);
    Point3D light = scene.getAllLights.elementAt(0).pos; ///new Point3D.init(88.0, 70.0, -500.0) ;  
    Vector3D lv = new Vector3D.init(light.x-hit.intersection.x, light.y-hit.intersection.y, light.z-hit.intersection.z);
    double light_dist = lv.length();
    lv.normalise();
 
    RGB hit_colour = new RGB.copy(hit_obj.texture.getColourAt(hit)); //hit.intersection.x, hit.intersection.y, hit.intersection.z));
    
    // Shadow test
    Ray shadow = new Ray.initPoint(hit.intersection, lv);
    double shadow_t = double.INFINITY;
    bool inshadow = false;
    for(Object3D obj in scene.getAllObjects) {
      double new_t = obj.calcT(shadow);
      
      if (new_t > 0.0 && new_t < shadow_t && new_t < light_dist) {
        shadow_t = new_t;
        break;
      }
    }
    if(shadow_t > 0.0 && shadow_t < double.INFINITY) {
      inshadow = true;
    }
    
    // point hit is not in shadow  - so do lighting calc 
    if(!inshadow) {
      // diffuse lighting
      double intens = max(0.01, lv.dotProduct(hit.normal));
      //* (800000 / (light_dist * light_dist) )
      // this is bullshit
      //intens = intens * (800000 / (light_dist * light_dist) );
      
      //print(hit_obj.material.no_shade);
      
      if(hit_obj.material.no_shade == true) {
        hit_colour.scale(1.0);
      } else {
        hit_colour.scale(intens);
      }

      // spec phong lighting
      double rv = max(0.0, hit.reflected.dotProduct(lv));  // angle between light and reflected ray
      double phong = pow(rv, hit_obj.material.hardness) * hit_obj.material.ks; // calc the Phong specular term
      hit_colour.blend(phong);      
      
    } else {
      hit_colour.scale(0.15);
    }
    
    if (ray.depth < scene.maxdepth)
    {
      if  (hit_obj.material.kr > 0.0)
      {
        Ray reflectray = new Ray.initPoint(hit.intersection, hit.reflected);
        reflectray.depth = ray.depth + 1;
        RGB reflcol = shadeRay(reflectray, x, y);
        reflcol.scale(hit_obj.material.kr);
        hit_colour.add(reflcol);
      }
    }
    
    return hit_colour;
  } // end of t hit block
  else {
    // Missed all objects - draw pixel from background
    if(ray.depth == 1)
      return RGB.black;
      //return ImageManager.getImage('background').getRGBPixel(x, y);
      //return scene.getBackgroundPixel(x, y); //out.drawBGPixel(scene.getBackgroundImageData, x, y);
    else
      return RGB.black;
  }
}

putMessage(String msg) {
  TextAreaElement ta = querySelector('#ta_msgs') as TextAreaElement;
  print(msg);
  //ta.scrollByLines(1);
  ta.appendText(msg + "\n");
}

clearMessages() {
  TextAreaElement ta = querySelector('#ta_msgs') as TextAreaElement;
  ta.text = "";
}

