/**
 * Purpose: Simple flat sloid colour texture
 * Notes:   
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_ray;

class TextureBasic extends Texture
{
  RGB colour;
  
  TextureBasic() {
    colour = RGB.white;
  }
  
  TextureBasic.init(this.colour);
  
  @override
  RGB getColourAt(Hit h) {
    return this.colour;
  }
}