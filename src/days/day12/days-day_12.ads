package Days.Day_12 with SPARK_Mode is
   type Map_Idx_T is range 1 .. 1000;
   
   type Map_Arr_T is array( Map_Idx_T range<>, Map_Idx_T range<>) of Character;
   
   type Map_Coord_R is record
      Row : Map_Idx_T;
      Col : Map_Idx_T;
   end record;
   
   function Minimum_Step_Path( Start_Loc: Map_Coord_R; End_Loc: Map_Coord_R; Map: Map_Arr_T ) return Natural;
   
end Days.Day_12;
