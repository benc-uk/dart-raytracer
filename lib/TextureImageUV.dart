/**
 * Purpose: Texture image file
 * Notes:   Point sampled only now
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_ray;

class TextureImageUV extends Texture
{
  static final int MODE_BILINEAR = 1;
  static final int MODE_NEAREST = 2;
  
  String _img_name;
  double _scale_x;
  double _scale_y;
  int mode = MODE_BILINEAR;
  
  TextureImageUV() {  
  }
  
  TextureImageUV.init(String img_name, String fn, this._scale_x, this._scale_y) {
    _img_name = img_name;
    ImageManager.addImage(_img_name, fn);
  }
  
  @override
  RGB getColourAt(Hit hit) {
    RGB textel = new RGB();
    
    Image i = ImageManager.getImage(_img_name);
    
    double w = i.width.toDouble() * _scale_x;
    double h = i.height.toDouble() * _scale_y;
    double x = (hit.u * w) % i.width;
    double y = (hit.v * h) % i.height;
    int px = x.floor(); 
    int py = y.floor();
        
    switch(mode) { 
      case 1:
        RGB p1 = i.getRGBPixel(px, py);
        RGB p2 = i.getRGBPixel(px+1, py);
        RGB p3 = i.getRGBPixel(px, py+1);
        RGB p4 = i.getRGBPixel(px+1, py+1);
     
        double fx = x - px;
        double fy = y - py;
        double fx1 = 1.0 - fx;
        double fy1 = 1.0 - fy;
         
        num w1 = fx1 * fy1;
        num w2 = fx  * fy1;
        num w3 = fx1 * fy;
        num w4 = fx  * fy;
            
        textel.r = p1.r * w1 + p2.r * w2 + p3.r * w3 + p4.r * w4;
        textel.g = p1.g * w1 + p2.g * w2 + p3.g * w3 + p4.g * w4;
        textel.b = p1.b * w1 + p2.b * w2 + p3.b * w3 + p4.b * w4;
        break;
      case 2:
        textel = i.getRGBPixel(px, py);
    }
    return textel;
  }
}