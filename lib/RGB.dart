/**
 * Purpose: Colour held as a RGBA tuple
 * Notes:   Range 0.0 - 1.0. Alpha is transparencey 0.0 = opaque, 1.0 = fully transparent 
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_graphics;

class RGB
{
  static final RGB black  = new RGB.init(0.0, 0.0, 0.0, 0.0);
  static final RGB white  = new RGB.init(1.0, 1.0, 1.0, 0.0);
  static final RGB red    = new RGB.init(1.0, 0.0, 0.0, 0.0);

  double r;
  double g;
  double b;
  double a;
  
  RGB() {
    r = 0.0; g = 0.0; b = 0.0; a = 0.0;
  }
  
  RGB.init(this.r, this.g, this.b, this.a);
  
  RGB.copy(RGB input) {
    r = input.r;   
    g = input.g;   
    b = input.b;   
    a = input.a;   
  }

  RGB.list(List<num> cl) {
    r = cl[0].toDouble();   
    g = cl[1].toDouble();   
    b = cl[2].toDouble();   
    a = cl[3].toDouble();   
  }
  
  blend(double f) {
    r = r * (1.0 - f) + f;       
    g = g * (1.0 - f) + f;       
    b = b * (1.0 - f) + f;      
  }
  
  scale(double f) {
    r = r * f;       
    g = g * f;       
    b = b * f;      
  }
  
  add(RGB colour) {
    r += colour.r;       
    g += colour.g;       
    b += colour.b;      
  }
  
  RGB addRGB(RGB colour) {
    RGB c = new RGB();
    c.r += r + colour.r;       
    c.g += g + colour.g;       
    c.b += b + colour.b;      
    return c;
  }
  
  scaleRGB(RGB color)
  {
    r *= color.r;
    g *= color.g;
    b *= color.b;
  }

  addSome(RGB color, double amount)
  {
    r += (color.r * amount);
    g += (color.g * amount);
    b += (color.b * amount);
  }
  
  String toString() {
    return "[$r, $g, $b, $a]";
  }
}
