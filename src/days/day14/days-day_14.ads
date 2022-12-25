package Days.Day_14 with SPARK_Mode is
   pragma Elaborate_Body;
   subtype Sand_Col_Idx is Natural range 250 .. 750;
   subtype Sand_Row_Idx is Natural range 0 .. 200;
   
   type Sand_Symbols_E is ( Air, Sand, Rock );
   type Sand_Grid_Lookup_T is array( Sand_Symbols_E ) of Character;
   
   -- Lookup to print the correct symbols in the grid
   Sand_Lookup: constant Sand_Grid_Lookup_T := ( Air => '.', Sand => 'o', Rock => '#' );
   
   type Sand_Arr_T is array( Sand_Row_Idx, Sand_Col_Idx ) of Sand_Symbols_E;

   procedure Count_Units_Coming_To_Rest( Grid: in out Sand_Arr_T; Count: out Natural );
end Days.Day_14;
