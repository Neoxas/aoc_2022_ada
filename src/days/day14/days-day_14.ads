package Days.Day_14 is
   pragma Elaborate_Body;
   subtype Sand_Col_Idx is Natural range 450 .. 550;
   subtype Sand_Row_Idx is Natural range 0 .. 200;
   
   type Sand_Symbols_E is ( Air, Sand, Rock );
   type Sand_Grid_Lookup_T is array( Sand_Symbols_E ) of Character;
   
   Sand_Lookup: constant Sand_Grid_Lookup_T := ( Air => '.', Sand => 'o', Rock => '#' );
   
   type Sand_Arr_T is array( Sand_Row_Idx, Sand_Col_Idx ) of Sand_Symbols_E;

end Days.Day_14;
