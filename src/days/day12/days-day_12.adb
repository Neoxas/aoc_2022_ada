with Ada.Containers.Formal_Hashed_Maps;
with Ada.Containers.Formal_Ordered_Sets;
with ADa.Text_IO; use Ada.Text_IO;
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
   type Node_R is record
      Map_Coord: Map_Coord_R;
      Length : Steps_T;
   end record;
   
   function Node_Less_Than (Left, Right: Node_R) return Boolean is
     ( Left.Length < Right.Length );
   -- Think this should be an ordered hash map as it allows me to remove from one and set for the other? Or have one as storage and one as not?
   package Nodes_P is new Formal_Ordered_Sets( Element_Type => Node_R,
                                               "<" => Node_Less_Than);
   use Nodes_P;
   
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
         Put_Line( "Getting shortest path" );
         Loc := Get_Shortest_Path( Queue );
         -- If it has never been visited, we can just skip it.
         if Element( Queue, Loc ) = Steps_T'Last then
            Put_Line( "Deleted element" );
            Delete( Queue, Loc );
         else
            Put_Line( "LOC: " & Loc'Image);
            Put_Line( "Loc length: " & Element( Queue, Loc )'Image );
            Delete( Queue, Loc );
            declare
               Neighbours : constant Neighbours_Arr_T := Get_Neighbours( Loc, Map );
            begin
               Put_Line( "Debug 1" );
               for Neighbour of Neighbours loop
                  Put_Line( "Neighbour: " & Neighbour'Image );
                  Put_Line( "Debug 2" );
                  -- If it is still present in the queue, we havent visted it yet.
                  if Contains( Queue, Neighbour ) then
                     Put_Line( "Debug 3" );
                     -- If we have visited, check to update it. Else add it
                     if Contains( Visited, Neighbour ) then
                        Put_Line( "Debug 4" );
                        if Element( Visited, Loc ) + 1 < Element( Visited, Neighbour ) then
                           Put_Line( "Debug 5" );
                           Replace( Visited, Neighbour, Element( Visited, Loc ) + 1 );
                           Replace( Queue, Neighbour, Element( Visited, Loc ) + 1 );
                        end if;
                     else
                        Put_Line( "Debug 6" );
                        Insert( Visited, Neighbour, Element( Visited, Loc ) + 1 );
                        Put_Line( "Debug 7" );
                        Replace( Queue, Neighbour, Element( Visited, Neighbour ));
                     end if;
                  end if;
               end loop;
            end;
         end if;
      end loop;
      Put_Line( "END DYKSTRA" );
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
      
      declare
         Visited_Map : Map_Arr_T( Map'First(1) .. Map'Last(1), Map'First(2) .. Map'Last(2)) := ( others => ( others => '.' ) );
      begin

         for Coord of Visited loop
            Visited_Map( Coord.Row, Coord.Col ) := 'X';
         end loop;
         
         Visited_Map( Start_Loc.Row, Start_Loc.Col ) := 'S';
         Visited_Map( End_Loc.Row, End_Loc.Col ) := 'E';

         for I in Visited_Map'Range( 1 ) loop
            for J in Visited_Map'Range( 2 ) loop
               Put( Visited_Map(I, J)'Image );
            end loop;
            Put_Line( "" );
         end loop;
      end;

      return Element( Visited, End_Loc );
      -- We want to go through every coordinate and add it to the Queue. We want to set all the length parameters to max.
      -- We then want to take the start node and remove it from the queue
      -- look at the adjoining nodes, if they are in the queue, we see their length and update it to be our current length + 1 if it is < their current length.
      -- If they aren't, then we have already visited them so this cannot be shorter route?
      -- Once all adjacent nodes have been visited, take the next shortest entry from the queue.
      -- Repeat until the queue is empty.
   end Minimum_Step_Path;

end Days.Day_12;
