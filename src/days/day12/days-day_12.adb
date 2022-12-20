package body Days.Day_12 with SPARK_Mode is

   function Minimum_Step_Path( Start_Loc: Map_Coord_R; End_Loc: Map_Coord_R; Map: Map_Arr_T ) return Natural is
      Steps : Natural := 0;
   begin
      -- Look at doing something like dykstra pathing for this. Can create a hash map on location for when nodes are visited.
      return Steps;
   end Minimum_Step_Path;

end Days.Day_12;
