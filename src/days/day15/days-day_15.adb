package body Days.Day_15 with SPARK_Mode is

   type Blocked_Row_R is record
      Row: Beacon_Row_Idx;
      Start_Col: Beacon_Col_Idx;
      End_Col: Beacon_Col_Idx;
   end record;
   
   package Blocked_Rows_P is new Formal_Vectors( Index_Type => Positive,
                                                Element_Type => Blocked_Row_R);
   use Blocked_Rows_P;
   
   
   function Get_Manhattan_Dist( Scan: Scan_R ) return Integer is
     ( abs( Scan.Signal.Col - Scan.Beacon.Col ) + abs( Scan.Signal.Row - Scan.Beacon.Row ) );
   
   procedure Add_Exclusion_To_Grid( Scan: Scan_R; Grid: Beacon_Arr_A ; Row_To_Check: Beacon_Col_Idx) is
      Manhat_Dist : constant Integer := Get_Manhattan_Dist( Scan );
      Sig renames Scan.Signal;
   begin
      -- Add beacon and singal markers
      if Scan.Signal.Row = Row_To_Check then
         Grid( Scan.Signal.Col ) := Signal;
      end if;
      
      if Scan.Beacon.Row = Row_To_Check then
         Grid( Scan.Beacon.Col ) := Beacon;
      end if;
      
      -- Signal is the source
      
      -- Top half of the triange
      -- Go from 0 to the manhattan distance
      for I in 0 .. Manhat_Dist loop
         declare
            -- Storage for Row we are on.
            R : constant Beacon_Row_Idx := Sig.Row - Manhat_Dist + I;
         begin
            if R = Row_To_Check then
               -- Go out to either way from col in increasing I increments
               for C in Sig.Col - I .. Sig.Col + I loop
                  -- If its not empty, we block it out
                  if Grid( C ) = Empty then
                     Grid( C ) := Blocked;
                  end if;  
               end loop;
            end if;
         end;
      end loop;
      
      -- Bottom half of the triange
      -- Go from 0 to the manhattan distance
      for I in 1 .. Manhat_Dist loop
         declare
            -- Storage for Row we are on.
            R : constant Beacon_Row_Idx := Sig.Row + I;
         begin
            if R = Row_To_Check then
               -- Go in to either way from max col to single in increasing I increments
               for C in Sig.Col - Manhat_Dist + I .. Sig.Col + Manhat_Dist - I loop
                  -- If its not empty, we block it out
                  if Grid( C ) = Empty then
                     Grid( C ) := Blocked;
                  end if;  
               end loop;
            end if;
         end;
      end loop;
      
   end Add_Exclusion_To_Grid;
   
   procedure Add_Beacons_To_Grid( Scan_Entries: Scan_Results_P.Vector; Grid: Beacon_Arr_A; Row_To_Check: Beacon_Row_Idx ) is
   begin
      for Scan of Scan_Entries loop
         Add_Exclusion_To_Grid( Scan, Grid, Row_To_Check );
      end loop;
   end Add_Beacons_To_Grid;

   function Count_Not_Empty_Entries_In_Row( Grid: Beacon_Arr_A ) return Natural is
      Count : Natural := 0;
   begin
      for Col in Grid'Range loop
         if Grid( Col ) = Blocked then
            Count := Count + 1;
         end if;
      end loop;
      
      return Count;
   end Count_Not_Empty_Entries_In_Row;

   procedure Add_Blocked_Row_For_Scan( Blocked: in out Blocked_Rows_P.Vector; Scan : Scan_R ) is
      Manhat_Dist : constant Integer := Get_Manhattan_Dist( Scan );
      Sig renames Scan.Signal;
   begin   
      -- Signal is the source
      
      -- Top half of the triange
      -- Go from 0 to the manhattan distance
      for I in 0 .. Manhat_Dist loop
         declare
            -- Storage for Row we are on.
            R : constant Beacon_Row_Idx := Sig.Row - Manhat_Dist + I;
         begin
            -- Go out to either way from col in increasing I increments
            Append( Blocked, (Row => R, Start_Col => Sig.Col - I, End_Col => Sig.Col + I ) );
         end;
      end loop;
      
      -- Bottom half of the triange
      -- Go from 0 to the manhattan distance
      for I in 1 .. Manhat_Dist loop
         declare
            -- Storage for Row we are on.
            R : constant Beacon_Row_Idx := Sig.Row + I;
         begin
            if R in Restricted_Row_Idx'Range then
               -- Go in to either way from max col to single in increasing I increments
               Append( Blocked, (Row => R, Start_Col => Sig.Col - Manhat_Dist + I, End_Col => Sig.Col + Manhat_Dist - I ) );
            end if;
         end;
      end loop;
   end Add_Blocked_Row_For_Scan;
   
   function Get_Blocked_Rows( Scan_Entries: Scan_Results_P.Vector ) return Blocked_Rows_P.Vector is
      Blocked : Blocked_Rows_P.Vector( 600_000 );
   begin
      for Scan of Scan_Entries loop
         Add_Blocked_Row_For_Scan( Blocked, Scan );
      end loop;
      
      return Blocked;
   end Get_Blocked_Rows;
   
   function Point_In_Blocked_Zone( Blocked: Blocked_Rows_P.Vector; Row: Restricted_Row_Idx; Col : Restricted_Col_Idx ) return Boolean is
   begin
      for Idx in First_Index( Blocked ) .. Last_Index( Blocked ) loop
         if Element( Blocked, Idx ).Row = Row then
            if Col in Element( Blocked, Idx ).Start_Col .. Element( Blocked, Idx ).End_Col then
               return True;
            end if;
         end if;
      end loop;
      
      return False;
   end Point_In_Blocked_Zone;
   
   function Find_Empty_Point( Scan_Entries: Scan_Results_P.Vector ) return Point_R is
      Blocked : constant Blocked_Rows_P.Vector := Get_Blocked_Rows( Scan_Entries );
   begin
      for I in Restricted_Row_Idx'Range loop
         for J in Restricted_Col_Idx'Range loop
            if not Point_In_Blocked_Zone( Blocked, I, J ) then
               return ( Row => I, Col => J );
            end if;
         end loop;
      end loop;
      -- Catch all end case
      return (Row  => 1, Col => 1);
   end Find_Empty_Point;

end Days.Day_15;
