/**
 * Purpose: Simple material properties, hardness, reflectivity etc used in lighting calculations 
 * Notes:   
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_ray;

class Material 
{
  double ka;
  double kd;
  double ks;
  double hardness;
  double kr;
  bool no_shade;
  
  Material() {
    ka = 0.7;
    kd = 0.8;
    ks = 0.9;
    hardness = 10.0;
    kr = 0.0;
    no_shade = false;
  }

  Material.init(this.ka, this.kd, this.ks, this.hardness, this.kr);
  
  Material.list(List ml) {
    ka = ml[0].toDouble();
    kd = ml[1].toDouble();
    ks = ml[2].toDouble();
    hardness = ml[3].toDouble();
    kr = ml[4].toDouble();
    no_shade = (ml[5] == 1);
  }
}