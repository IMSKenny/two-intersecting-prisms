unit Mouse;

interface

type
   ButtonType = ( LeftButton, RightButton, MiddleButton );
   ButtonSet  = set of ButtonType;

{ ������� ������������ �������� }

procedure ResetMouse( var Ok : Boolean;  var ButtonNumber : Word );
procedure GetMouse( var Pressed : ButtonSet; var X, Y : integer );
procedure MoveMouse( X, Y : integer );

{ �������������� ������� }

function ButtonPressed : Boolean;
function LeftButtonPressed : Boolean;
function RightButtonPressed : Boolean;
function TwoButtonPressed : Boolean;
procedure GetMouseXY( var X, Y : integer );

{=========================================================================}

implementation

uses
   GraphABC;
   
var
   MouseX, MouseY, MButton: integer;   
   LeftPressed, RightPressed: Boolean;
   

procedure ResetMouse( var Ok : Boolean;  var ButtonNumber : Word );
begin
   Ok := true;
   ButtonNumber := 2;
end;

procedure GetMouse( var Pressed : ButtonSet; var X, Y : integer );
begin
   GetMouseXY( X, Y );
   if LeftButtonPressed then
      Pressed := [LeftButton]
   else
      Pressed := [];
   if RightButtonPressed then
      Include( Pressed, RightButton );
end;

procedure MoveMouse( X, Y : integer );
begin
end;

function ButtonPressed : Boolean;
begin
   ButtonPressed := LeftButtonPressed or RightButtonPressed;
end;

function LeftButtonPressed : Boolean;
begin
   LeftButtonPressed := LeftPressed;
end;

function RightButtonPressed : Boolean;
begin
   RightButtonPressed := RightPressed
end;

function TwoButtonPressed : Boolean;
begin
   TwoButtonPressed := LeftButtonPressed and RightButtonPressed;
end;

procedure GetMouseXY( var X, Y : integer );
begin
   x := MouseX;
   y := MouseY;
end;

{
OnMouseDown: procedure (x,y,mousebutton: integer); 
        ������� ������� �� ������ ����. (x,y) - ���������� ������� ���� � ������ ����������� �������, mousebutton = 1, ���� ������ ����� ������ ����, � 2, ���� ������ ������ ������ ����  
OnMouseUp: procedure (x,y,mousebutton: integer); 
        ������� ������� ������ ����. (x,y) - ���������� ������� ���� � ������ ����������� �������, mousebutton = 1, ���� ������ ����� ������ ����, � 2, ���� ������ ������ ������ ����   
OnMouseMove: procedure (x,y,mousebutton: integer); 
        ������� ����������� ����. (x,y) - ���������� ������� ���� � ������ ����������� �������, mousebutton = 0, ���� ������ ���� �� ������, 1, ���� ������ ����� ������ ����, � 2, ���� ������ ������ ������ ����.   
}

procedure MouseUp(x, y, mousebutton: integer);
begin
   if mousebutton = 1 then
      LeftPressed := false
   else if mousebutton = 2 then
      RightPressed := false;
   MButton := mousebutton;
   MouseX := x;
   MouseY := y;
end;

procedure MouseDown(x, y, mousebutton: integer);
begin
   if mousebutton = 1 then
      LeftPressed := true
   else if mousebutton = 2 then
      RightPressed := true;
   MButton := mousebutton;
   MouseX := x;
   MouseY := y;
end;

procedure MouseMove(x, y, mousebutton: integer);
begin
   MButton := mousebutton;
   MouseX := x;
   MouseY := y;
end;

begin
   MouseX := 0;
   MouseY := 0;
   MButton := 0;
   LeftPressed := false;
   RightPressed := false;
   
   OnMouseDown := MouseDown;
   OnMouseUp := MouseUp;
   OnMouseMove := MouseMove;
end.
