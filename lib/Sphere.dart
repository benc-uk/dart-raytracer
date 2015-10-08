/**
 * Purpose: Sphere object 
 * Notes:   
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_ray;

class Sphere extends Object3D
{
  double _r2;
  
  Sphere(Point3D p, double radius) {
    _r2 = radius * radius;
    setPosition(p);
  }
  
  @override
  double calcT(Ray ray) {
    // Copy the input ray and transform to object space
    _obj_ray = new Ray.initPoint(ray.pos, ray.dir);
    _obj_ray.transform(_reverse);
    
    // double a = *** Not required for 'pure' spheres (of uniform radius) ***
    double b = 2.0 * _obj_ray.pos.dotProduct(_obj_ray.dir);
    double c = _obj_ray.pos.dotProduct(_obj_ray.pos) - _r2;
    
    double d = b*b - 4.0*c;
    
    // miss
    if (d <= 0.0)
      return 0.0;
    
    d = sqrt(d);
    double t1 = (-b+d)/2.0;
    double t2 = (-b-d)/2.0;

    if (t1.abs() < Object3D.THRES || t2.abs() < Object3D.THRES)
      return 0.0;
    
    // Ray is inside if there is only 1 positive root
    // Added for refractive transparency
    if (t1 < 0 && t2 > 0)
    {
      _rayinside = true;
      return t2;
    }
    if (t2 < 0 && t1 > 0)
    {
      _rayinside = true;
      return t1;
    }
    
    return (t1 < t2) ? t1 : t2;
  }
  
  @override
  Hit calcHitDetails(double t, Ray ray) {
    Hit hit = new Hit();
    
    // Calc hit point in world space
    hit.intersection = ray.getPoint(t);
    
    // Normal on a sphere is really easy in object space
    Point3D inter_object_space = _obj_ray.getPoint(t);
    hit.normal = new Vector3D.init(inter_object_space.x, inter_object_space.y, inter_object_space.z);
    hit.normal.normalise();
    
    // Reflected ray
    Vector3D reflect_dir = ray.dir.reflect(hit.normal);
    hit.reflected = reflect_dir;
    
    return hit;
  }
}