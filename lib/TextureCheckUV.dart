/**
 * Purpose: Classic checkerboard
 * Notes:   
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_ray;

class TextureCheckUV extends Texture
{
  RGB colour1;
  RGB colour2;
  double size;      // Size of the blocks of color 1
  
  TextureCheckUV() {
    colour1 = RGB.white;
    colour2 = RGB.black;
    size = 1.0;    
  }
  
  TextureCheckUV.init(this.colour1, this.colour2, this.size);
  
  @override
  RGB getColourAt(Hit hit) {
    double h_size = size / 2.0;
    
    if(hit.u % size < h_size) 
      if(hit.v % size < h_size) 
        return colour1;
      else
        return colour2;        
    else
      if(hit.v % size < h_size) 
        return colour2;   
      else
        return colour1;
  }
}