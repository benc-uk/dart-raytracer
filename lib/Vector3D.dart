/**
 * Purpose: A 3 tuple 3D vector of normalised length
 * Notes:   
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_vecmath;

class Vector3D extends Point3D
{
  Vector3D() {
  }
  
  Vector3D.init(double ix, double iy, double iz) {
    x = ix; y = iy; z = iz;
  }
  
  /*
   * Create point from list (for JSON loading)
   */
  Vector3D.list(List<num> vl) {
    x = vl[0].toDouble(); y = vl[1].toDouble(); z = vl[2].toDouble();
    normalise();
  }
  
  double length() {
      return sqrt ((x*x) + (y*y) + (z*z));
  }
  
  normalise() {
    double oneover = 1 / length();
    mult(oneover);
  }

  /*
   * Reflection of a vector (ray) around a normal (used for specular shading and reflections)
   */
  Vector3D reflect(Vector3D norm) {
    Vector3D ref = new Vector3D();
    
    double k = -this.dotProduct(norm);
    ref.x = this.x + 2 * norm.x * k;
    ref.y = this.y + 2 * norm.y * k;
    ref.z = this.z + 2 * norm.z * k;
    ref.normalise();
    
    return ref;
  }
  
}