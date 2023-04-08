program Test3D_W;

uses
   Display, BGL, Polyhedr, Trans3D, Trans2D, Space3D, Rotator, OutText, Light3D,
   WBuffer;

const
   a = 250;
   z0 = 1600;   //расстояние от камеры
   FACET_PRISM_1 = 5;  //кол-во граней первой призмы  (min 3)
   FACET_PRISM_2 = 8;  //кол-во граней второй призмы  (min 3)
   RADIUS_PRISM_1 = 0.4;  //радиус первой призмы  (900*600/0.6)
   RADIUS_PRISM_2 = 0.5;  //радиус второй призмы  (900*600/0.6)
   HEIGHT_PRISM_1 = 1.5;  //высота первой призмы  (900*600/2)
   HEIGHT_PRISM_2 = 2;  //высота второй призмы  (900*600/2) 
   
var
   Poly        : tPolyhedr;
   M, S        : Mat3D;
   M2D         : Mat2D;
   df          : Vec3D;
   
   T, T0: integer;
   TS: string;
   C: integer;
   FPS, MS: real;
   
   Light: Vec3D;
   
procedure  OutCopyright;
begin
   OutTextXY(10, (GetMaxY - 20) div 2, ' Mamonchikova N.S., 2022');
end;
   
procedure  OutTextW;
begin
   OutTextXY(10, 8, 'Two intersecting prisms');
   OutTextXY(10, 16, '   ');
   OutTextXY(10, 24, 'Z(W)-buffer algorithm');
   OutTextXY(10, 32, '  ');
   OutTextXY(10, 40, 'Removing non-face faces');
   OutTextXY(10, 48, ' ');
   OutTextXY(10, 56, 'Gamma correction');
   OutTextXY(10, 64, ' ');
   OutTextXY(10, 72, ' ');
end;
   
begin
   SetTextColor($FFBF8C);
   SetBkColor($3B4A5C);
   SetColor($FF6502);
   
   Light.x := 1;
   Light.y := 1;
   Light.z := 1;
   
   SetLightDir(Light);
   SetLightInt(50, 205);
   

//  MakePrismsTwoX( Poly, 8);
   MakePrismsTwoXn( Poly, FACET_PRISM_1, FACET_PRISM_2, 
                          RADIUS_PRISM_1, RADIUS_PRISM_2, 
                          HEIGHT_PRISM_1, HEIGHT_PRISM_2 );
   
   Trans3D.MakeS(a, a, a, S);
   TransPolyhedr(Poly, S);
   
   SetPolyhedrColor(Poly, $ff, 0.4, 0.5, 0);
   
   Trans2D.MakeS(1, -1, M2D);
   Trans2D.Translate(GetMaxX/2, GetMaxY/2, M2D);
   
   df.x := 0.01;
   df.y := 0.01;
   df.z := 0.0001;
   
   SetRadiusXY(a*sqrt(3)/2);
   SetCenterZ(GetMaxX div 2, GetMaxY div 2);
   
   CalcNormals(Poly);
   
   T0 := milliseconds;
   C := 0;
   
   repeat
      C := C + 1;
    
      GetRotation(df);
      
      MakeRx(df.x, M);
      RotateY(df.y, M);
      RotateZ(df.z, M);
      
      TransPolyhedr(Poly, M);
      RotateNormals(Poly, M);
      
      ToScreen(Poly, M2D, z0);
      
      ClearDevice;
      ClearWBuffer;
      
//      DrawWirePolyhedr(Poly);
//      DrawSolidConvexColorPolyhedr(Poly, z0);
      DrawPolyhedrW(Poly, z0);
//      DrawPolyhedrWGouraud(Poly, z0);
      
      OutCopyright;
      OutTextW;      
      
      T := milliseconds - T0;
      FPS := C/T*1000;
      MS := T/C;
      Str(FPS:0:1, TS);
      OutTextXY((GetMaxX - 80) div 2, (GetMaxY - 20) div 2, 'FPS ' + TS); 
      Str(MS:0:1, TS);
      OutTextXY((GetMaxX - 160) div 2, (GetMaxY - 20) div 2, 'MS ' + TS); 
      
      Draw;
   
   until false;
   
end.
