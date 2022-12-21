with Ada.Containers.Formal_Hashed_Maps;
with Ada.Containers.Formal_Ordered_Sets;
package body Days.Day_12 with SPARK_Mode is
   use Ada.Containers;

   subtype Steps_T is Natural range 0 .. 1_000_000;

   function Coord_Hash(Key: Map_Coord_R ) return Hash_Type is
      -- Terrible hashing method. Basically offset the Row so it is > max ever col so they cant intersect.
      (Hash_Type(Key.Row + Map_Idx_T'Last + 1 + Key.Col));
   -- Define a hash map for storing our visited nodes and steps taken to get there.
   package Coord_Map_P is new Formal_Hashed_Maps( 
                                                    Key_Type => Map_Coord_R, 
                                                    Element_Type => Steps_T,
                                                    Hash => Coord_Hash);
   use Coord_Map_P;
   
   -- Map can have at max 1 to 4 neighbours
   subtype Neighbours_Idx_T is Natural range 1 .. 4;
   type Neighbours_Arr_T is array( Neighbours_Idx_T range<>) of Map_Coord_R;
   
   function Get_Neighbours( Coord: Map_Coord_R; Map: Map_Arr_T ) return Neighbours_Arr_T is
      Up, Down, Left, Right: Boolean := False;
      Count : Natural := 0;
      Curr_Coord : constant Character := Map( Coord.Row, Coord.Col );
   begin
      -- if we can go left, set it.
      if Coord.Col /= Map'First(2) then
         Left := Map( Coord.Row, Coord.Col - 1 ) in 'a' .. Character'Succ( Curr_Coord );
         if Left then
            Count := Count + 1;
         end if;
      end if;
      
      -- If we can go right, then set the value
      if Coord.Col /= Map'Last(2) then
         Right := Map( Coord.Row, Coord.Col + 1 ) in 'a' .. Character'Succ( Curr_Coord );
         if Right then
            Count := Count + 1;
         end if;
      end if;
      
      -- If we can go Up, then set it
      if Coord.Row /= Map'First(1) then
         -- Cant go Up so not set.
         Up := Map( Coord.Row - 1, Coord.Col ) in 'a' .. Character'Succ( Curr_Coord );
         if Up then
            Count := Count + 1;
         end if;
      end if;
      
      -- If we can go down, then set it
      if Coord.Row /= Map'Last(1) then
         -- Cant go down so not set
         Down := Map( Coord.Row + 1, Coord.Col ) in 'a' .. Character'Succ( Curr_Coord );
         if Down then
            Count := Count + 1;
         end if;
      end if;

      declare
         Neighbours : Neighbours_Arr_T( 1 .. Count );
         Idx: Neighbours_Idx_T := Neighbours_Idx_T'First;
      begin
         if Up then
            Neighbours( Idx ) := (Row => Coord.Row - 1, Col => Coord.Col);
            Idx := Idx + 1;
         end if;
         
         if Down then
            Neighbours( Idx ) := (Row => Coord.Row + 1, Col => Coord.Col);
            Idx := Idx + 1;
         end if;
         
         if Left then
            Neighbours( Idx ) := (Row => Coord.Row, Col => Coord.Col - 1);
            Idx := Idx + 1;
         end if;
         
         if Right then
            Neighbours( Idx ) := (Row => Coord.Row, Col => Coord.Col + 1);
         end if;
         
         return Neighbours;
      end;
   end Get_Neighbours;
   
   function Get_Shortest_Path( Queue: Coord_Map_P.Map ) return Map_Coord_R is
      Curr: Map_Coord_R := Key( Queue, First(Queue) );
      Max_Len : Steps_T := Element( Queue, Curr );
   begin
      for I in Queue loop
         if Element( Queue, I ) < Max_Len then
            Curr := Key(Queue, I);
            Max_Len := Element( Queue, I );
         end if;
      end loop;
      
      return Curr;
   end Get_Shortest_Path;
      
   procedure Dykstra( Start_Loc: Map_Coord_R; Map: Map_Arr_T; Queue: in out Coord_Map_P.Map; Visited : in out Coord_Map_P.Map ) is
      Loc: Map_Coord_R := Start_Loc;
   begin
      -- Update start location to be 0 steps away
      Insert( Container => Visited, Key => Start_Loc , New_Item => 0 );
      Replace( Container => Queue, Key => Start_Loc , New_Item => 0 );
      
      -- Main dykstra loop
      while not Is_Empty( Queue ) loop
         Loc := Get_Shortest_Path( Queue );
         -- If it has never been visited, we can just skip it.
         -- Yes this is jank but I really dont care (:
         if Element( Queue, Loc ) = Steps_T'Last then
            Delete( Queue, Loc );
         else
            Delete( Queue, Loc );
            declare
               Neighbours : constant Neighbours_Arr_T := Get_Neighbours( Loc, Map );
            begin
               for Neighbour of Neighbours loop
                  -- If it is still present in the queue, we havent visted it yet.
                  -- If its not in the queue, we have already hit it so ignore it
                  if Contains( Queue, Neighbour ) then
                     -- If we have visited, check to update it. Else just add it
                     if Contains( Visited, Neighbour ) then
                        if Element( Visited, Loc ) + 1 < Element( Visited, Neighbour ) then
                           Replace( Visited, Neighbour, Element( Visited, Loc ) + 1 );
                           Replace( Queue, Neighbour, Element( Visited, Loc ) + 1 );
                        end if;
                     else
                        Insert( Visited, Neighbour, Element( Visited, Loc ) + 1 );
                        Replace( Queue, Neighbour, Element( Visited, Neighbour ));
                     end if;
                  end if;
               end loop;
            end;
         end if;
      end loop;
   end Dykstra;
   
   function Minimum_Step_Path( Start_Loc: Map_Coord_R; End_Loc: Map_Coord_R; Map: Map_Arr_T ) return Natural is
      Visited: Coord_Map_P.Map(Capacity => Count_Type(Map'Last(1) * Map'Last(2)), Modulus => Hash_Type(2*22));
      Queue: Coord_Map_P.Map(Capacity => Count_Type(Map'Last(1) * Map'Last(2)), Modulus => Hash_Type(2*22));
   begin
      -- Look at doing something like dykstra pathing for this. Can create a hash map on location for when nodes are visited.
      -- Use something like A := Character'Pred( A ); to check if its in range.
      for I in Map'Range( 1 ) loop
         for J in Map'Range( 2 ) loop
            -- Add all elements to queue
            Insert( Queue, (Col => J, Row => I), Steps_T'Last );
         end loop;
      end loop;
      
      Dykstra( Start_Loc, Map, Queue, Visited );

      return Element( Visited, End_Loc );
   end Minimum_Step_Path;

end Days.Day_12;
