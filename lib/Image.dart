part of lib_graphics;

class Image
{
  ImageData _data;
  ImageElement _image;
  Completer _completer;
  CanvasRenderingContext2D _ctx;
  String _filename;
  int _width;
  int _height;
  
  Image(this._filename);
  
  Future loadImageFile() {
    _completer = new Completer();
    
    // Fake/hidden image for background 
    _image = new ImageElement();
    _image.src = _filename;
    
    // Wait for it to load, and return future/completer
    return _image.onLoad.first.then( (_) { _imageLoaded(); } );
  }
  
  // Callback for loading the image
  _imageLoaded() {
    _ctx = new CanvasElement(width: _image.width, height: _image.height).context2D;
    _ctx.drawImage(_image, 0, 0);
    _data = _ctx.getImageData(0, 0, _image.width, _image.height);
    print("${_image.width}, ${_image.height}");
    this._width  = _image.width;
    this._height = _image.height;
    _completer.complete();
  }
  
  int get height => _height;
  int get width => _width;
    
  RGB getRGBPixel(int x, int y) {
    x = x.clamp(0, _image.width-1);
    y = y.clamp(0, _image.height-1);
    
    // flip Y 
    y = (y - _height+1).abs();
    
    RGB pixel = new RGB();
    int index = (x + y * _image.width) * 4;

    pixel.r = _data.data[index + 0] / 256.0; 
    pixel.g = _data.data[index + 1] / 256.0;
    pixel.b = _data.data[index + 2] / 256.0;
    pixel.a = (_data.data[index + 3] - 256).abs() / 256.0;
    return pixel;
  }     
  
  double bilinear(num x, num y, int offset) {
    num percentX = 1.0 - (x - x.floor());
    num percentY = y - y.floor();
  
    double top = _data.data[offset + y.ceil() * width * 4 + x.floor() * 4] * percentX + _data.data[offset + y.ceil() * width * 4 + x.ceil() * 4] * (1.0 - percentX);
    double bottom = _data.data[offset + y.floor() * width * 4 + x.floor() * 4] * percentX + _data.data[offset + y.floor() * width * 4 + x.ceil() * 4] * (1.0 - percentX);
  
    return top * percentY + bottom * (1.0 - percentY);
  }
}