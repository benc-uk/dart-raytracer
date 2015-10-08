/**
 * Purpose: Abstract class for all textures
 * Notes:   
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_ray;

abstract class Texture
{
  RGB getColourAt(Hit h);
}