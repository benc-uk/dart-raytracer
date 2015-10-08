/**
 * Library: Container for all the core ray tracing classes
 * 
 * Notes:   
 * Author:  Ben Coleman
 * Changes: 
 */

library lib_ray;

import 'lib_vecmath.dart';
import 'lib_graphics.dart';

import 'dart:math';
import 'dart:html';
import 'dart:convert';
import 'dart:async';

part 'Ray.dart';
part 'Material.dart';
//part 'Stats.dart';
part 'Hit.dart';
part 'Light.dart';
part 'Camera.dart';

part 'Texture.dart';
part 'TextureBasic.dart';
part 'TextureCheckUV.dart';
part 'TextureCheck.dart';
part 'TextureImageUV.dart';

part 'Scene.dart';
part 'Object3D.dart';
part 'Sphere.dart';
part 'Plane.dart';