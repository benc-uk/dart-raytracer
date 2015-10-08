/**
 * Purpose: Classic checkerboard
 * Notes:   
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_ray;

class TextureCheck extends Texture
{
  RGB colour1;
  RGB colour2;
  double size;      // Size of the blocks of color 1
  
  TextureCheck() {
    colour1 = RGB.white;
    colour2 = RGB.black;
    size = 1.0;    
  }
  
  TextureCheck.init(this.colour1, this.colour2, this.size);
  
  @override
  RGB getColourAt(Hit hit) {
    double h_size = size / 2.0;
    double xi = hit.intersection.x;
    double yi = hit.intersection.y;
    double zi = hit.intersection.z;
    //double xi = (hit.intersection.x < 0)? hit.intersection.x - h_size : hit.intersection.x;
    //double yi = (hit.intersection.y < 0)? hit.intersection.y - h_size : hit.intersection.y;
    //double zi = (hit.intersection.z < 0)? hit.intersection.z - h_size : hit.intersection.z;

    if ((yi % size).abs() < h_size)
    {
      if ((xi % size).abs() < h_size)
      {
        if ((zi % size).abs() < h_size)
        {
          return colour1;
        }
        return colour2;
      }
      else
      {
        if ((zi % size).abs() < h_size)
        {
          return colour2;
        }
        return colour1;
      }
    } 
    else
    {
      if ((xi % size).abs() < h_size)
      {
        if ((zi % size).abs() < h_size)
        {
          return colour2;
        }
        return colour1;
      }
      else
      {
        if ((zi % size).abs() < h_size)
        {
          return colour1;
        }
        return colour2;
      }
    } // End if. Whew!
  }
}