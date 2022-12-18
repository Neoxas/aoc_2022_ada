with Ada.Containers.Formal_Vectors; Use Ada.Containers;
package Days.Day_9 with SPARK_Mode is
   pragma Elaborate_Body;
   MAX_ROPE_INST : constant := 5000;
   -- Head/Tail can be moved either up down left or right
   type Rope_Dir is ( U,D,L,R );
   -- Distance the Head can be moved
   subtype Rope_Dist_T is Natural range 0 .. 100;
   -- Range of allowed instructions
   subtype Rope_Inst_Idx_T is Positive range 1 .. MAX_ROPE_INST;
   -- Instruction must be a direction for a distance
   type Rope_Inst_R is record
      Dir: Rope_Dir;
      Dist: Rope_Dist_T;
   end record;
   
   -- List of instrutions to move the head around
   package Rope_Inst_Vec_P is new Formal_Vectors( Index_Type => Rope_Inst_Idx_T,
                                                  Element_Type => Rope_Inst_R);

   function Count_Visited_Spaces( Instructions: Rope_Inst_Vec_P.Vector ) return Natural;
   
   private
   -- Allowed grid indexes
   subtype Grid_Idx_T is Integer range 1 .. 1000;
   -- Build a 1000x1000 grid of Booleans, representing if a point has been visited
   type Grid_Arr_T is array(Grid_Idx_T, Grid_Idx_T) of Boolean;
   
   -- Point to track location of head an tail
   type Point_R is record
      Col_Idx: Grid_Idx_T;
      Row_Idx: Grid_Idx_T;
   end record;
end Days.Day_9;
