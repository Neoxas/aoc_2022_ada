with Ada.Containers.Formal_Vectors; Use Ada.Containers;
package Days.Day_9 with SPARK_Mode is
   pragma Elaborate_Body;
   
   -- Allowed grid indexes
   type Grid_Idx_T is range 1 .. 1000;
   -- Build a 1000x1000 grid of Booleans, representing if a point has been visited
   type Grid_Arr_T is array(Grid_Idx_T, Grid_Idx_T) of Boolean;
   
   -- Point to track location of head an tail
   type Point_R is record
      Col_Idx: Grid_Idx_T;
      Row_Idx: Grid_Idx_T;
   end record;
   
   -- Head/Tail can be moved either up down left or right
   type Direction is ( U,D,L,R );
   -- Distance the Head can be moved
   subtype Distance_T is Natural range 0 .. 100;
   -- Range of allowed instructions
   subtype Instruction_Idx_T is Positive range 1 .. 5000;
   -- Instruction must be a direction for a distance
   type Instruction_R is record
      Dir: Direction;
      Dist: Distance_T;
   end record;
   
   -- List of instrutions to move the head around
   package Instruction_Vec_P is new Formal_Vectors( Index_Type => Instruction_Idx_T,
                                                    Element_Type => Instruction_R);
   

end Days.Day_9;
