part of lib_graphics;

// Should be a singleton, but can't be arsed to figure out singletons with constructure parameters

class ImageOut
{
  static CanvasRenderingContext2D _context;
  static ImageData _img_data;
  int _width;
  int _height;  
  CanvasElement _ce;
  
  ImageOut(canvas_dom_id) {
    _ce = querySelector(canvas_dom_id) as CanvasElement;
    _context = _ce.getContext('2d');
    _width = _ce.width;
    _height = _ce.height;
    
    _img_data = _context.createImageData(_width, _height);
  }

  drawPixel(RGB c, int x, int y) {
    int index = (x + y * _width) * 4;

    _img_data.data[index + 0] = (c.r * 255).ceil();
    _img_data.data[index + 1] = (c.g * 255).ceil();
    _img_data.data[index + 2] = (c.b * 255).ceil();
    _img_data.data[index + 3] = 255 - ((c.a * 255).ceil());
  }

  updateCanvas() {
    _context.putImageData(_img_data, 0, 0, 0, 0, _width, _height);
  }
  
  clearCanvas() {
    _context.clearRect(0, 0, _width, _height);
  }
  
  int get width => _width;
  int get height => _height;
  
  /*drawBGPixel(ImageData bg, int x, int y) {
    int index = (x + y * width) * 4;
    // Background image will tile/repeat
    int bgindex = ((x % bg.width) + (y % bg.height) * bg.width) * 4;

    _img_data.data[index + 0] = bg.data[bgindex + 0];
    _img_data.data[index + 1] = bg.data[bgindex + 1];
    _img_data.data[index + 2] = bg.data[bgindex + 2];
    _img_data.data[index + 3] = bg.data[bgindex + 3];
  }*/
  
  
  /*Future clearCanvasBG() {
    _completer = new Completer();
    _img_data = _context.createImageData(width, height);
    
    image = new ImageElement(src: "background.png");
    
    // I don't really understand this voodoo
    return image.onLoad.first.then( (_) { drawBackgroundImage(); } );
  }

  drawBackgroundImage() {
    _context.drawImage(image, 0, 0);
    _img_data = _context.getImageData(0, 0, width, height);
    _completer.complete();
  }*/
}
