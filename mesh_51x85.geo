Mesh.MshFileVersion = 2.2;
///Parametrization:
//
// It is assumed that the XY-data arrays are flat *at the surface* and
// corresponding data are not changing vertically across a thin layer. 
//
// .... these are the horizontal coordinates of the lower-left (south-west) end of the data array in the mesh [m]:
//
DataRefX=0.0;
DataRefY=0.0;
//
// .... this spacing of the data array [m]:
//
DataSpacingX=3200.0;
DataSpacingY=3200.0;
//
// ... number of data points in east-west (X) and north-south (Y) direction:
//
DataNumX=51;
DataNumY=85;
//
// Note: the resolution specified here should roughly match the resolution of the actual data as input data are interpolated to the resolution in the mesh
//
// ... this is the "thickness" of the data array = the thickness of the vertical layer. 
//
DataMeshSizeVertical=3200;
//
// ... this is the thickness of region below the data area. We call this the core region which is the focus of the inversion
//
CoreThickness=50000;
//
// ... there is also an air layer and this is its thickness [m] (no updates for density and magnetization here)
//
AirLayerThickness=50000;
//
// ... there is padding around the core and air layer. For the subsurface there will be updates in padding region but not for the air layer  
//
PaddingX=100000.0;
PaddingY=100000.0;
PaddingZ=100000.0;
PaddingAir=50000.0;
//
// ... these are factors by which the DataMeshSizeVertical is raised in the air layer and in the core. 
//
MeshSizeAirFactor=10;
MeshSizeCoreFactor=5;
//
// ... these are factors by which the core and air layer mesh size are raised for the padding zone. 
//
MeshSizePaddingFactor=2;
// 
ProgressionType=1;
DataLX=DataSpacingX*(DataNumX-1);
DataLY=DataSpacingY*(DataNumY-1);
Depth=CoreThickness+PaddingY;


MeshSizeAir=10*DataMeshSizeVertical;
MeshSizeCore=5*DataMeshSizeVertical;

MeshSizeBase=2*MeshSizeCore;
MeshSizePaddingAir=2*MeshSizeAir;
MeshSizePaddingSurface=2*MeshSizeCore;

DataMeshGround=DataMeshSizeVertical;

//Core region:
Point(1)={DataRefX,DataRefY, -CoreThickness, MeshSizeCore};
Point(2)={DataRefX,DataRefY, 0., DataMeshSizeVertical};
Point(4)={DataRefX,DataRefY, AirLayerThickness, MeshSizeAir};

Point(5)={DataRefX+DataLX,DataRefY, -CoreThickness, MeshSizeCore};
Point(6)={DataRefX+DataLX,DataRefY, 0., DataMeshSizeVertical};
Point(8)={DataRefX+DataLX,DataRefY, AirLayerThickness, MeshSizeAir};

Point(9)={DataRefX,DataRefY+DataLY, -CoreThickness, MeshSizeCore};
Point(10)={DataRefX,DataRefY+DataLY, 0., DataMeshSizeVertical};
Point(12)={DataRefX,DataRefY+DataLY, AirLayerThickness, MeshSizeAir};

Point(13)={DataRefX+DataLX,DataRefY+DataLY, -CoreThickness, MeshSizeCore};
Point(14)={DataRefX+DataLX,DataRefY+DataLY, 0., DataMeshSizeVertical};
Point(16)={DataRefX+DataLX,DataRefY+DataLY, AirLayerThickness, MeshSizeAir};

Line(1) = {6,14};
Line(2) = {14,10};
Line(3) = {10,2};
Line(4) = {2,6};

Line Loop (1) = {1:4};
Plane Surface(1)={1};
out[]=Extrude {0,0,DataMeshSizeVertical}{Surface{1};Layers{1};};

Physical Volume("DataArea")={1,26,13,17,25,21};

Line(30) = {5,13};
Line(31) = {13,14};
Line(32) = {6,5};
Line Loop(30)={30,31,-1,32};
Line(33) = {5,1};
Line(34) = {1,2};
Line Loop(33) = {-32,-4,-34,-33};
Line(35) = {1,9};
Line(36) = {9,10};
Line Loop(35) = {35,36,3,-34};
Line(38) = {9,13};
Line Loop(38) = {-38,36,-2,-31};
Line Loop(39) = {38,-30,33,35};
Plane Surface(30)={30};
Plane Surface(33)={33};
Plane Surface(35)={35};
Plane Surface(38)={38};
Plane Surface(39)={39};
Surface Loop(40) = {1,30,33,35,38,39};
Volume(2) = {40};
Physical Volume("Base")={2};

Line(40) = {17,8};
Line(41) = {8,16};
Line(42) = {16,18};
Line Loop(40)={-40,6,-42,-41};
Line(43) = {4,8};
Line(44) = {4,26};
Line Loop(43) = {-43,44,9,40};
Line(45) = {4,12};
Line(46) = {12,22};
Line Loop(45) = {45,46,8,-44};
Line(48) = {12,16};
Line Loop(48) = {48,42,7,-46};
Line Loop(49) = {41,-48,-45,43};
Plane Surface(40)={40};
Plane Surface(43)={43};
Plane Surface(45)={45};
Plane Surface(48)={48};
Plane Surface(49)={49};
Surface Loop(50) = {26,40,43,45,48,49};
Volume(3) = {50};
Physical Volume("Air")={3};

//Padding:
Point(101)={DataRefX-PaddingX,DataRefY-PaddingY, -Depth, MeshSizeBase};
Point(102)={DataRefX-PaddingX,DataRefY-PaddingY, 0, MeshSizePaddingSurface};
Point(103)={DataRefX-PaddingX,DataRefY-PaddingY, AirLayerThickness+PaddingAir, MeshSizePaddingAir};

Point(104)={DataRefX+DataLX+PaddingX,DataRefY-PaddingY, -Depth, MeshSizeBase};
Point(105)={DataRefX+DataLX+PaddingX,DataRefY-PaddingY, 0, MeshSizePaddingSurface};
Point(106)={DataRefX+DataLX+PaddingX,DataRefY-PaddingY, AirLayerThickness+PaddingAir, MeshSizePaddingAir};

Point(107)={DataRefX-PaddingX,DataRefY+DataLY+PaddingY, -Depth, MeshSizeBase};
Point(108)={DataRefX-PaddingX,DataRefY+DataLY+PaddingY, 0, MeshSizePaddingSurface};
Point(109)={DataRefX-PaddingX,DataRefY+DataLY+PaddingY, AirLayerThickness+PaddingAir, MeshSizePaddingAir};

Point(110)={DataRefX+DataLX+PaddingX,DataRefY+DataLY+PaddingY, -Depth, MeshSizeBase};
Point(111)={DataRefX+DataLX+PaddingX,DataRefY+DataLY+PaddingY, 0, MeshSizePaddingSurface};
Point(112)={DataRefX+DataLX+PaddingX,DataRefY+DataLY+PaddingY, AirLayerThickness+PaddingAir, MeshSizePaddingAir};

//+
Line(129) = {101, 104};
//+
Line(130) = {104, 105};
//+
Line(131) = {104, 110};
//+
Line(132) = {105, 111};
//+
Line(133) = {111, 110};
//+
Line(134) = {110, 107};
//+
Line(135) = {111, 108};
//+
Line(136) = {107, 108};
//+
Line(137) = {108, 102};
//+
Line(138) = {107, 101};
//+
Line(139) = {101, 102};
//+
Line(140) = {102, 105};
//+
Line(141) = {103, 102};
//+
Line(142) = {103, 106};
//+
Line(143) = {106, 112};
//+
Line(144) = {112, 109};
//+
Line(145) = {103, 109};
//+
Line(146) = {109, 108};
//+
Line(147) = {112, 111};
//+
Line(148) = {105, 106};
//+
Line Loop(117) = {137, 140, 132, 135};
//+
Plane Surface(117) = {1, 117};
//+
Line Loop(118) = {142, 143, 144, -145};
//+
Plane Surface(118) = {118};
//+
Line Loop(119) = {146, 137, -141, 145};
//+
Plane Surface(119) = {119};
//+
Line Loop(120) = {146, -135, -147, 144};
//+
Plane Surface(120) = {120};
//+
Line Loop(121) = {143, 147, -132, 148};
//+
Plane Surface(121) = {121};
//+
Line Loop(122) = {132, 133, -131, 130};
//+
Plane Surface(122) = {122};
//+
Line Loop(123) = {130, -140, -139, 129};
//+
Plane Surface(123) = {123};
//+
Line Loop(124) = {138, 139, -137, -136};
//+
Plane Surface(124) = {124};
//+
Line Loop(125) = {136, -135, 133, 134};
//+
Plane Surface(125) = {125};
//+
Line Loop(126) = {129, 131, 134, 138};
//+
Plane Surface(126) = {126};
//+
Line Loop(127) = {148, -142, 141, 140};
//+
Plane Surface(127) = {127};
//+
Physical Surface("TopFace") = {118};
//+
Physical Surface("BottomFace") = {126};
//+
Surface Loop(4) = {125, 124, 126, 123, 122, 30, 38, 35, 33,39,117};
//+
Volume(4) = {4};
//+
Physical Volume("PaddingBase") = {4};
//+
Surface Loop(5) = {118, 121,127,120,119,49,48,40,43,45,21,25,13,17,117};
//+
Volume(5) = {5};
//+
Physical Volume("PaddingAir") = {5};
