/**
 * Purpose: Core ray class, has point of orgin and direction vector 
 * Notes:   
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_ray;

class Ray
{
  Point3D pos;
  Vector3D dir; 
  int depth;
  static int _total = 0;  // For stats only
  
  
  /**
   * Create a ray at the origin, pointing at origin. Useless, don't use this
   */
  Ray() {
    pos = new Point3D(); 
    dir = new Vector3D(); 
    depth = 1;
    
    _total++;
  }
  
  /**
   * Create a ray at postion p1 with vector p2, normalised for safety
   */
  Ray.init(double p1x, double p1y, double p1z, double p2x, double p2y, double p2z) {
    Vector3D v = new Vector3D.init(p2x, p2y, p2z);
    v.normalise();
    pos = new Point3D.init(p1x, p1y, p1z);
    dir = v;
    depth = 1;
        
    _total++;
  }
  
  /**
   * As above
   */
  Ray.initPoint(Point3D p, Vector3D d) {
    pos = new Point3D.init(p.x, p.y, p.z); 
    dir = new Vector3D.init(d.x, d.y, d.z);
    depth = 1;
        
    _total++;
  }
  
  /**
   * Create a ray at point p1 aimed at p2, so that direction vector is calculated 
   */
  Ray.pointAt(Point3D p1, Point3D p2) {
    pos = p1; 
    dir = new Vector3D(); 
    Point3D temp = p2 - p1;
    dir.x = temp.x;
    dir.y = temp.y;
    dir.z = temp.z;
    dir.normalise();
    depth = 1;
        
    _total++;
  }
  
  /**
   * Get point along ray t distance
   */
  Point3D getPoint(double t) {
    return new Point3D.init(pos.x + (t * dir.x), pos.y + (t * dir.y), pos.z + (t * dir.z));
  }
  
  void transform(TransMatrix tm) {
    tm.transformP(pos);
    tm.transformV(dir);
  }
  
  @override
  toString() {
    return '$pos -> $dir';
  }
  
  static int get getRayTotal => _total;
}