/**
 * Purpose: Core 3D point class with math support
 * Notes:   
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_vecmath;

class Point3D 
{
  double x;
  double y;
  double z;

  /** 
   * Create null point at origin
   */
  Point3D() {
    this.x = 0.0; this.y = 0.0; this.z = 0.0;
  }

  /*
   * Create point at given co-ords
   */
  Point3D.init(this.x, this.y, this.z);
  
  /*
   * Create point from list (for JSON loading)
   */
  Point3D.list(List<num> pl) {
    x = pl[0].toDouble(); y = pl[1].toDouble(); z = pl[2].toDouble();
  }
  
  
  @override
  toString() {
    return '[$x, $y, $z]';
  }
  
  plus(double n) {
    x += n; y += n;z += n;
  } 
  
  plusPoint(Point3D p) {
    x += p.x; y += p.y; z += p.z;
  } 
  
  Point3D operator +(Point3D p) {
      return new Point3D.init(x + p.x, y + p.y, z + p.z);
  }
  
  sub(double n) {
    x -= n; y -= n;z -= n;
  } 
  
  subPoint(Point3D p) {
    x -= p.x; y -= p.y; z -= p.z;
  } 
  
  Point3D operator -(Point3D p) {
      return new Point3D.init(x - p.x, y - p.y, z - p.z);
  }  
  
  mult(double n) {
    x *= n; y *= n;z *= n;
  } 
  
  multPoint(Point3D p) {
    x *= p.x; y *= p.y; z *= p.z;
  } 
  
  Point3D operator *(Point3D p) {
      return new Point3D.init(x * p.x, y * p.y, z * p.z);
  }   

  div(double n) {
    x *= n; y *= n;z *= n;
  } 
  
  divPoint(Point3D p) {
    x *= p.x; y *= p.y; z *= p.z;
  } 
  
  Point3D operator /(Point3D p) {
      return new Point3D.init(x / p.x, y / p.y, z / p.z);
  }  
  
  Point3D copy() {
    return new Point3D.init(x, y, z);
  }
  
  /*
   * Flip position, used more with Vector3D subclass 
   */
  void invert() {
    x = -x; y = -y; z = -z;
  }
  
  /*
   * Calculate dot product of two vectors
   */
  double dotProduct(Point3D p) {
    return (x * p.x) + (y * p.y) + (z * p.z);
  }
  
  String toJson() {
    return "{$x, $y, $z}";
  }
}