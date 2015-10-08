part of lib_ray;

class Light
{
  Point3D pos;
  
  Light(this.pos);
  
  Light.list(List<num> list) {
    pos = new Point3D.list(list);
  }
}