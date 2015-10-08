part of lib_graphics;

class ImageManager
{
  static final ImageManager _singleton = new ImageManager._init();
  
  ImageManager();
  static Map<String, Image> _imgs = new Map();
  static Completer _comp;
  
  static void addImage(String name, String filename) {
    _imgs[name] = new Image(filename);
  }
  
  static Future loadAllImages() {
    _comp = new Completer();
    List waiters = new List();
    for(String fn in _imgs.keys) {
      waiters.add( _imgs[fn].loadImageFile() );
    }
    
    Future.wait(waiters).then((_) => _comp.complete(null));
    return _comp.future;
  }
  
  ImageManager._init() {
    _comp = new Completer();
    _imgs = new Map();
  }
  
  static Image getImage(String n) {
    return _imgs[n];
  }
}