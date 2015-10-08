/**
 * Purpose: A transform matrix
 * Notes:   
 * Author:  Ben Coleman
 * Changes: 
 */

part of lib_vecmath;

class TransMatrix
{
  static final int X = 0;
  static final int Y = 1;
  static final int Z = 2;
  TwoDArray _mat;
  static final int SIZE = 4;
  static final double PI180 = PI / 180.0;
  
  /*
   * 
   */
  TransMatrix() {
    _mat = new TwoDArray(SIZE);
  }
  
  /*
   * 
   */
  TransMatrix.indentity() {
    _mat = new TwoDArray(SIZE);
    
    for(int r = 0; r < _mat.size; r++) {
      for(int c = 0; c < _mat.size; c++) {
        if(r == c)
          _mat.set(c, r, 1.0);
      }
    }  
  }
  
  /*
   * 
   */
  TransMatrix.translate(Point3D p) {
    _mat = new TwoDArray(SIZE);
    
    for(int r = 0; r < _mat.size; r++) {
      for(int c = 0; c < _mat.size; c++) {
        if(r == c)
          _mat.set(c, r, 1.0);
      }
    } 
    
    _mat.set(3, 0, p.x);
    _mat.set(3, 1, p.y);
    _mat.set(3, 2, p.z);
  }

  // ----------------------------------------------------------------------------------------- //
  // Create a rotation transform matrix; to rotate according to the X, Y & Z values of the tuple 's'
  // ----------------------------------------------------------------------------------------- //
  TransMatrix.rotate(double x, double y, double z)
  {
    _mat = new TwoDArray(4);
    TransMatrix result = new TransMatrix.indentity();
    
    double cosx = cos(toRadians(x));
    double sinx = sin(toRadians(x));
    double cosy = cos(toRadians(y));
    double siny = sin(toRadians(y));
    double cosz = cos(toRadians(z));
    double sinz = sin(toRadians(z));
    
    // Rotate about x axis
    this._mat.set(1,1, cosx);
    this._mat.set(2,2, cosx);
    this._mat.set(1,2, sinx);
    this._mat.set(2,1, 0.0 - sinx);
    
    TransMatrix temp_matrix = new TransMatrix.indentity();
    // Rotate about y axis
    temp_matrix._mat.set(0,0,cosy);
    temp_matrix._mat.set(2,2,cosy);
    temp_matrix._mat.set(0,2, (0.0 - siny));
    temp_matrix._mat.set(2,0,siny);
    this.multiply(temp_matrix);
      
    temp_matrix = new TransMatrix.indentity();
    // Rotate about z axis
    temp_matrix._mat.set(0, 0, cosz);
    temp_matrix._mat.set(1, 1, cosz);
    temp_matrix._mat.set(0, 1, sinz);
    temp_matrix._mat.set(1, 0, 0.0 - sinz);
    this.multiply(temp_matrix);  
  }
  
  double toRadians(double d) {
    return d * PI180;
  }
  
  /*
   * 
   */
  void transformP(Point3D p) {
    p.x = p.x * _mat.get(0, 0) + p.y * _mat.get(1, 0) +  p.z * _mat.get(2, 0) + 1 * _mat.get(3, 0);
    p.y = p.x * _mat.get(0, 1) + p.y * _mat.get(1, 1) +  p.z * _mat.get(2, 1) + 1 * _mat.get(3, 1);
    p.z = p.x * _mat.get(0, 2) + p.y * _mat.get(1, 2) +  p.z * _mat.get(2, 2) + 1 * _mat.get(3, 2);
  }
  
  void transformV(Vector3D p) {
    p.x = p.x * _mat.get(0, 0) + p.y * _mat.get(1, 0) +  p.z * _mat.get(2, 0);
    p.y = p.x * _mat.get(0, 1) + p.y * _mat.get(1, 1) +  p.z * _mat.get(2, 1);
    p.z = p.x * _mat.get(0, 2) + p.y * _mat.get(1, 2) +  p.z * _mat.get(2, 2);
  }
  
  void multiply(TransMatrix tm) {
    TransMatrix temp_matrix = new TransMatrix();
    
    for (int i = 0 ; i < 3 ; i++) {
      for (int j = 0 ; j < 3 ; j++) {
        for (int k = 0 ; k < 3 ; k++) {
          double val = temp_matrix._mat.get(i,j);
          temp_matrix._mat.set( i, j, (val += (this._mat.get(i, k) * tm._mat.get(k, j))) );
        }
      }
    }
    
    for (int i = 0 ; i < SIZE ; i++) {
      for (int j = 0 ; j < SIZE ; j++) {
        this._mat.set( i, j, temp_matrix._mat.get(i, j) );
      }
    }   
  }
  
  
  /*
   * 
   */
  String toString() {
    String out = "[";
    
    for(int r = 0; r < _mat.size; r++) {
      for(int c = 0; c < _mat.size; c++) {
        out += _mat.get(c, r).toString() + ", ";
      }
      out += "\n";
    }
    return out + "]";
  }

}

// ####################################################################################################
//
// Quick and dirty square 2D array wrapper
//
// ####################################################################################################
class TwoDArray {
  int _size = 1;
  List<double> _data;
  
  get size => _size;
  
  TwoDArray(int size) {
    _size = size;
    _data = new List(size * size);
    for(int i = 0; i < (size * size); i++) {
      _data[i]  = 0.0;
    }
  }
  
  double get(int c, int r) {
    return _data[r * _size + c];
  }
  
  void set(int c, int r, double val) {
    _data[r * _size + c] = val;
  }
  
}