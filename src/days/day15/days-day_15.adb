package body Days.Day_15 with SPARK_Mode is

   function Get_Manhattan_Dist( Scan: Scan_R ) return Integer is
     ( abs( Scan.Signal.Col - Scan.Beacon.Col ) + abs( Scan.Signal.Row - Scan.Beacon.Row ) );
   
   procedure Add_Exclusion_To_Grid( Scan: Scan_R; Grid: Beacon_Arr_A ) is
      Manhat_Dist : constant Integer := Get_Manhattan_Dist( Scan );
      Sig renames Scan.Signal;
   begin
      -- Add beacon and singal markers
      if Scan.Signal.Row in Restricted_Row_Idx'Range and Scan.Signal.Col in Restricted_Col_Idx'Range then
         Grid( Restricted_Row_Idx(Scan.Signal.Row), Restricted_Col_Idx( Scan.Signal.Col ) ) := Signal;
      end if;
      
      if Scan.Beacon.Row in Restricted_Row_Idx'Range and Scan.Beacon.Col in Restricted_Col_Idx'Range then
         Grid( Restricted_Row_Idx( Scan.Signal.Row ), Restricted_Col_Idx( Scan.Beacon.Col ) ) := Beacon;
      end if;
      
      -- Signal is the source
      
      -- Top half of the triange
      -- Go from 0 to the manhattan distance
      for I in 0 .. Manhat_Dist loop
         declare
            -- Storage for Row we are on.
            R : constant Beacon_Row_Idx := Sig.Row - Manhat_Dist + I;
         begin
            -- Go out to either way from col in increasing I increments
            for C in Sig.Col - I .. Sig.Col + I loop
               if R in Restricted_Col_Idx'Range and C in Restricted_Col_Idx'Range then
                  -- If its not empty, we block it out
                  if Grid( R, C ) = Empty then
                     Grid( R, C ) := Blocked;
                  end if;
               end if;
            end loop;
         end;
      end loop;
      
      -- Bottom half of the triange
      -- Go from 0 to the manhattan distance
      for I in 1 .. Manhat_Dist loop
         declare
            -- Storage for Row we are on.
            R : constant Beacon_Row_Idx := Sig.Row + I;
         begin
            -- Go in to either way from max col to single in increasing I increments
            for C in Sig.Col - Manhat_Dist + I .. Sig.Col + Manhat_Dist - I loop
               if R in Restricted_Row_Idx'Range and C in Restricted_Col_Idx'Range then
                  -- If its not empty, we block it out
                  if Grid( R, C ) = Empty then
                     Grid( R, C ) := Blocked;
                  end if;  
               end if;
            end loop;
         end;
      end loop;
      
   end Add_Exclusion_To_Grid;
   
   procedure Add_Beacons_To_Grid( Scan_Entries: Scan_Results_P.Vector; Grid: Beacon_Arr_A ) is
   begin
      for Scan of Scan_Entries loop
         Add_Exclusion_To_Grid( Scan, Grid );
      end loop;
   end Add_Beacons_To_Grid;

   function Count_Not_Empty_Entries_In_Row( Grid: Beacon_Arr_A; Row_To_Check: Beacon_Row_Idx ) return Natural is
      Count : Natural := 0;
   begin
      for Col in Grid'Range(2) loop
         if Grid( Row_To_Check, Col ) = Blocked then
            Count := Count + 1;
         end if;
      end loop;
      
      return Count;
   end Count_Not_Empty_Entries_In_Row;

end Days.Day_15;
