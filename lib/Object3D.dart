/**
 * Purpose: Abstract class for all objects
 * Notes:   
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_ray;

abstract class Object3D
{
  Point3D _pos;
  Texture _texture;
  Material _mat;
  bool _rayinside = false;
  TransMatrix _reverse;
  TransMatrix _forward;
  String name = "";
  Ray _obj_ray;
  
  static final double THRES = 0.001;
  
  /*
   * Generic constructor 
   */
  Object3D() {
    _pos = new Point3D();  
    _texture = new TextureBasic();
    _mat = new Material();
    _reverse = new TransMatrix.indentity();
    _forward = new TransMatrix.indentity();
  }
  
  /*
   * Getters & setters 
   */
  void set setTexture(Texture t) { _texture = t; }
  void set setMaterial(Material m) { _mat = m; }
  Texture get texture => _texture;
  Material get material => _mat;
  Point3D get position => _pos;
  TransMatrix get reverse_transform => _reverse;
  
  /*
   * Abstract methods that need concreate implementation by subclasses
   */
  double calcT(Ray r);
  Hit calcHitDetails(double t, Ray ray);
  
  /*
   * Move object to new position, based on its center point
   */
  setPosition(Point3D p) {
    _pos = p;
    
    _forward = new TransMatrix.translate(p);
    
    Point3D temp = p.copy();
    temp.invert();
    _reverse = new TransMatrix.translate(temp);
  }

  /*
   * 
   */
  String toString() {
    return "Object $name";
  }
  
}

