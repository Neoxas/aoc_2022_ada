package body Days.Day_9 with SPARK_Mode is
   function Same_Col( Head: Point_R; Tail: Point_R) return Boolean is
     ( Head.Col_Idx = Tail.Col_Idx );
   
   function Same_Row( Head: Point_R; Tail: Point_R) return Boolean is
     ( Head.Row_Idx = Tail.Row_Idx );
   
   function Col_Dist( Head: Point_R; Tail: Point_R) return Integer is
   begin
      return Head.Col_Idx - Tail.Col_Idx;
   end Col_Dist;

   function Row_Dist( Head: Point_R; Tail: Point_R) return Integer is
   begin
      return Head.Row_Idx - Tail.Row_Idx;
   end Row_Dist;
   
   function Points_Touching( Head: Point_R; Tail: Point_R ) return Boolean is
      ( Col_Dist( Head, Tail) in -1 .. 1 and Row_Dist( Head, Tail ) in -1 .. 1 );
   
   procedure Move_Point( Point: in out Point_R; Dir: Rope_Dir) is
   begin
      case Dir is
         when U =>
            Point.Row_Idx := Point.Row_Idx + 1;
         when D =>
            Point.Row_Idx := Point.Row_Idx - 1;
         when R =>
            Point.Col_Idx := Point.Col_Idx + 1;
         when L =>
            Point.Col_Idx := Point.Col_Idx - 1;
      end case;
   end Move_Point;
   
   procedure Catch_Diagonal( Head: Point_R; Tail: in out Point_R; Dir: Rope_Dir ) is
   begin
      -- Move in the direction the head moved
      Move_Point( Tail, Dir );
      -- If we moved up or down, then we need to move in the column to follow
      if Dir in U | D then
         -- If head is less, its to the left. Else its to the right.
         if Head.Col_Idx < Tail.Col_Idx then
            Move_Point( Tail, L );
         elsif Head.Col_Idx > Tail.Col_Idx then
            Move_Point( Tail, R );
         end if;
         
      -- Else if we moved left or right we need to move the row to follow
      elsif Dir in L | R then
         -- If the head is less than the tail, its below so move down. Else move up.
         if Head.Row_Idx < Tail.Row_Idx then
            Move_Point( Tail, D );
         elsif Head.Row_Idx > Tail.Row_Idx then
            Move_Point( Tail, U );
         end if;
      end if;
   end Catch_Diagonal;
   
   procedure Record_Tail_Location( Grid: in out Grid_Arr_T; Tail: Point_R; Count: in out Natural ) is
   begin
      -- If we havent visited it before, add it and count it
      if not Grid( Tail.Row_Idx, Tail.Col_Idx ) then
         Grid( Tail.Row_Idx, Tail.Col_Idx ) := True;
         Count := Count + 1;
      end if;
   end Record_Tail_Location;
   
   function Count_Single_Knot_Visited_Spaces( Instructions: Rope_Inst_Vec_P.Vector ) return Natural is
      Grid : Grid_Arr_T := ( others => (others => False) );
      -- Start in the middle of the grid.
      Head : Point_R := (Row_Idx => Grid_Idx_T'Last / 2, Col_Idx => Grid_Idx_T'Last / 2);
      Tail : Point_R := (Row_Idx => Grid_Idx_T'Last / 2, Col_Idx => Grid_Idx_T'Last / 2);
      Count : Natural := 0;
   begin
      -- Record start location
      Record_Tail_Location( Grid, Tail, Count );
      
      for Inst of Instructions loop
         for I in 1 .. Inst.Dist loop
            -- Move head
            Move_Point( Head, Inst.Dir );
            -- Check if we are not touching
            if not Points_Touching(Head, Tail) then

               -- If we are in the same row or col, follow the direction it went in.
               if Same_Col( Head, Tail ) or Same_Row( Head, Tail ) then
                  Move_Point(Tail, Inst.Dir);
               else
                  Catch_Diagonal( Head, Tail, Inst.Dir );
               end if;

               -- Update our tail location
               Record_Tail_Location( Grid, Tail, Count );
            end if;
         end loop;
      end loop;

      return Count;
   end Count_Single_Knot_Visited_Spaces;

   function Count_X_Knot_Visited_Spaces( Instructions: Rope_Inst_Vec_P.Vector; Knots: Positive ) return Natural is
      Grid : Grid_Arr_T := ( others => (others => False) );
      
      -- Store all the knots we want to track
      type Knot_Arr_T is array( 1 .. Knots ) of Point_R;
      Knots_Arr : Knot_Arr_T := ( others => ( Row_Idx => Grid_Idx_T'Last / 2, Col_Idx => Grid_Idx_T'Last / 2) );
      -- Keep track of first and last array
      Head renames Knots_Arr(Knots_Arr'First);
      Tail renames Knots_Arr(Knots_Arr'Last);
      
      Count : Natural := 0;
   begin
      -- Record start location
      Record_Tail_Location( Grid, Head, Count );
      
      for Inst of Instructions loop
         for I in 1 .. Inst.Dist loop
            -- Move head
            Move_Point( Head, Inst.Dir );
            -- Follow all our knots through.
            for I in Knots_Arr'First + 1 .. Knots_Arr'Last loop
               -- Check if we are not touching
               if not Points_Touching(Knots_Arr(I - 1), Knots_Arr(I)) then
                  -- If we are in the same row or col, follow the direction it went in.
                  if Same_Col( Knots_Arr(I - 1), Knots_Arr(I) ) or Same_Row( Knots_Arr(I - 1), Knots_Arr(I) ) then
                     -- NEED TO UPDATE THIS TO FIND RIGHT DIRECTION FOR TRAILING KNOTS!
                     Move_Point(Knots_Arr(I), Inst.Dir);
                  else
                     Catch_Diagonal( Knots_Arr(I - 1), Knots_Arr(I), Inst.Dir );
                  end if;
               end if;
            end loop;
            -- Update our tail location
            Record_Tail_Location( Grid, Tail, Count );
         end loop;
      end loop;

      return Count;
   end Count_X_Knot_Visited_Spaces;

end Days.Day_9;
