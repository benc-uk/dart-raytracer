/**
 * Purpose: Sphere object 
 * Notes:   
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_ray;

class Plane extends Object3D {
  Vector3D _normal;
  Vector3D _normal_reverse;
  double _vd;
  double _width = 10.0;
  double _height = 10.0;
  Point3D _intersectio_pre;
  double u, v;

  Plane(Point3D p, Vector3D direction, this._width, this._height) {
    _normal = new Vector3D.init(direction.x, direction.y, direction.z);
    _normal_reverse = new Vector3D.init(direction.x, direction.y, direction.z);
    _normal.normalise();
    _normal_reverse.normalise();
    _normal_reverse.invert();

    setPosition(p);
  }

  @override
  double calcT(Ray ray) {
    _obj_ray = new Ray.initPoint(ray.pos, ray.dir);
    _obj_ray.transform(_reverse);

    // When ray -> P + tV = 0
    // t = -(N dot P + D) / (N dot V)
    // vo = -(N dot P + D) and vd = (N dot V)
    _vd = _obj_ray.dir.dotProduct(_normal);
    if (_vd == 0.0) return 0.0;
    double vo = -((_normal.dotProduct(_obj_ray.pos)));

    double t = (vo / _vd);
    if (t.abs() < Object3D.THRES) return 0.0;

    Point3D intersection_object = _obj_ray.getPoint(t);
    if (intersection_object.x > _width || intersection_object.x < -_width) return 0.0;
    if (intersection_object.y > _height || intersection_object.y < -_height) return 0.0;
    u = (intersection_object.x + _width) / (_width * 2);
    v = (intersection_object.y + _height) / (_height * 2);
    
    return t;
  }

  @override
  Hit calcHitDetails(double t, Ray inray) {
    Hit hit = new Hit();

    hit.u = u; hit.v = v;
    
    hit.intersection = inray.getPoint(t);
    /*new Point3D();
    hit.intersection.x = inray.pos.x + (t * inray.dir.x);
    hit.intersection.y = inray.pos.y + (t * inray.dir.y);
    hit.intersection.z = inray.pos.z + (t * inray.dir.z);*/

    if (_vd < 0.0) hit.normal = _normal; else hit.normal = _normal_reverse;

    //_reverse.transNormal(norm);
    //norm.normalise();

    Vector3D r = new Vector3D();
    double k = -inray.dir.dotProduct(hit.normal);
    r.x = inray.dir.x + 2 * hit.normal.x * k;
    r.y = inray.dir.y + 2 * hit.normal.y * k;
    r.z = inray.dir.z + 2 * hit.normal.z * k;
    r.normalise();
    hit.reflected = r;

    return hit;
  }
}
