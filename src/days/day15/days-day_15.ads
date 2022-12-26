with Ada.Containers.Formal_Vectors;
package Days.Day_15 is
   use Ada.Containers;
   
   type Beacon_Grid_E is ( Empty, Beacon, Signal, Blocked );
   
   type Beacon_Chr_Lookup_T is array( Beacon_Grid_E ) of Character;
   BEACON_GRID_LOOKUP : constant Beacon_Chr_Lookup_T := ( Empty => '.', 
                                                          Beacon => 'B', 
                                                          Signal => 'S', 
                                                          Blocked => '#' );
   
   subtype Beacon_Row_Idx is Integer range -20 .. 200;
   subtype Beacon_Col_Idx is Integer range -200 .. 200;
   
   type Point_R is record 
      Row : Beacon_Row_Idx;
      Col : Beacon_Col_Idx;
   end record;
   
   type Scan_R is record 
      Beacon: Point_R;
      Signal: Point_R;
   end record;
   
   package Scan_Results_P is new Formal_Vectors( Index_Type => Positive,
                                                 Element_Type => Scan_R );
   
   type Beacon_Arr_T is array( Beacon_Row_Idx, Beacon_Col_Idx ) of Beacon_Grid_E;
   
   procedure Add_Beacons_To_Grid( Scan_Entries: Scan_Results_P.Vector; Grid: in out Beacon_Arr_T );

   function Count_Not_Empty_Entries_In_Row( Grid: Beacon_Arr_T; Row: Beacon_Row_Idx ) return Natural;
end Days.Day_15;
