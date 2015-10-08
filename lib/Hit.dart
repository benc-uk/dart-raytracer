part of lib_ray;

class Hit
{
  Point3D intersection;
  Vector3D normal;
  Vector3D reflected;
  double u, v = 0.0;
}