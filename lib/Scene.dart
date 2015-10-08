/**
 * Purpose: Holds all objects, lights, camera etc plus global details  
 * Notes:   
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_ray;

class Scene
{
  List<Object3D> _objs;
  List<Light> _lights;
  Camera _cam;
  int maxdepth = 11;

  // All this junk for bg images
  /*CanvasElement _bgcanvas;
  CanvasRenderingContext2D _bgctx;
  ImageData _bgimagedata;
  ImageElement _bgimage;
  Completer _bgcompleter;
  Completer _scompleter;*/
  
  Scene(ImageOut io) {
   /* _bgcanvas = new CanvasElement(width: io.width, height: io.height);
    _bgctx = _bgcanvas.context2D;
    _bgctx.clearRect(0, 0, io.width, io.height);
    _bgimagedata = _bgctx.createImageData(1, 1);*/
    
    _objs = new List();
    _lights = new List();
  }
  
  addObject(Object3D o) {
    _objs.add(o);
  }
  
  addLight(Light l) {
    _lights.add(l);
  }
  
  /*Future addBackground(String bg_img_filename) {
    _bgcompleter = new Completer();
    
    // Fake/hidden image for background 
    _bgimage = new ImageElement();
    _bgimage.src = "scenes/backgrounds/$bg_img_filename";
    return _bgimage.onLoad.first.then( (_) { _backgroundLoaded(); } );
  }*/
  
  /*
  RGB getBackgroundPixel(int x, int y) {
    RGB pixel = new RGB();
    int index = (x + y * _bgimagedata.width) * 4;

    pixel.r = _bgimagedata.data[index + 0] / 255.0; //= (c.r * 255).ceil();
    pixel.g = _bgimagedata.data[index + 1] / 255.0; //= (c.g * 255).ceil();
    pixel.b = _bgimagedata.data[index + 2] / 255.0; //= (c.b * 255).ceil();
    pixel.a = (_bgimagedata.data[index + 3] - 255).abs() / 255.0; //= 255 - ((c.a * 255).ceil());
    return pixel;
  }  */
  
  // Callback for loading the image
  /*_backgroundLoaded() {
    _bgctx.drawImage(_bgimage, 0, 0);
    _bgimagedata = _bgctx.getImageData(0, 0, _bgimage.width, _bgimage.height);
    _bgcompleter.complete();
  }*/
  
  loadSceneData(String scene_data) {
    parseScene(scene_data);
  }
  
  saveScene() {
  }
  
  parseScene(String json_str) {

    try {
      JsonDecoder json_decode = new JsonDecoder();
      Map data = json_decode.convert(json_str);
      
      if(data['background'] != null) {
        ImageManager.addImage('background', "scenes/backgrounds/" + data['background']);
      } else {
        //_scompleter.complete(null);
      }
      
      for(Map o in data['objects']) {
        
        Object3D new_obj;
        switch(o['type'].toString()) {
          case "Sphere":
            new_obj = new Sphere(new Point3D.list(o['pos']), o['radius']);
            break;
          case "Plane":
            new_obj = new Plane(new Point3D.list(o['pos']), new Vector3D.list(o['dir']), o['width'], o['height']);
            break;            
        }
        
        Texture texture;
        Map json_texture = o['texture'];
        switch(json_texture['type'].toString()) {
          case "Basic":
            texture = new TextureBasic();
            (texture as TextureBasic).colour = new RGB.list(json_texture['colour']);
            break;
          case "Check": 
            texture = new TextureCheck.init(new RGB.list(json_texture['colour1']), new RGB.list(json_texture['colour2']), json_texture['size']);
            break; 
          case "CheckUV": 
            texture = new TextureCheckUV.init(new RGB.list(json_texture['colour1']), new RGB.list(json_texture['colour2']), json_texture['size']);
            break;   
          case "Image":
            texture = new TextureImageUV.init(json_texture['name'].toString(), "scenes/textures/"+json_texture['filename'], json_texture['scale'][0], json_texture['scale'][1]);
            break;  
        }

        Material mat = new Material.list(o['material']);
        new_obj.setMaterial = mat;
        new_obj.setTexture = texture;

        addObject(new_obj);
      }
      
      for(Map l in data['lights']) {
        Light light = new Light.list(l['pos']);
        addLight(light);
      }
      
    } catch(exception, stackTrace) {
      print("Scene parsing error: " + exception.toString());
      //print(stackTrace);
    }
    //return _scompleter.future;
  }

  List<Object3D> get getAllObjects => _objs;
  List<Light> get getAllLights => _lights;
}