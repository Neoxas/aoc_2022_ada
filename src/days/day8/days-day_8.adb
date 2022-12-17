package body Days.Day_8 with SPARK_Mode is
   function Is_Row_Visible( Tree: Tree_T; Trees : Tree_Arr; Start_Idx: Tree_Col_Idx_T; End_Idx: Tree_Col_Idx_T; Row_Idx: Tree_Row_Idx_T ) return Boolean is
     (for all J in Start_Idx .. End_Idx => Trees(Row_Idx, J) < Tree);
   
   function Is_Col_Visible( Tree: Tree_T; Trees : Tree_Arr; Start_Idx: Tree_Row_Idx_T; End_Idx: Tree_Row_Idx_T; Col_Idx: Tree_Col_Idx_T ) return Boolean is
     (for all J in Start_Idx .. End_Idx => Trees(J, Col_Idx) < Tree);
   
   function Count_Visible_Trees( Trees: Trees_R ) return Natural is
      Tree_Count: Natural := Natural'First;
   begin
      -- Go for inner squares only, as some trees are visible from the outside
      for I in Trees.Trees'First(1) + 1 .. Trees.Last_Row - 1 loop
         for J in Trees.Trees'First(2) + 1 .. Trees.Last_Col - 1 loop
            -- If we are visible in any regard, add a count.
            if Is_Row_Visible( Trees.Trees(I,J), Trees.Trees, Trees.Trees'First(2), J - 1, I) or 
              Is_Row_Visible( Trees.Trees(I,J), Trees.Trees, J + 1, Trees.Last_Col, I) or 
              Is_Col_Visible( Trees.Trees(I,J), Trees.Trees, Trees.Trees'First(1), I - 1, J) or
              Is_Col_Visible( Trees.Trees(I,J), Trees.Trees, I + 1, Trees.Last_Row, J)
            then
               Tree_Count := Tree_Count + 1;
            end if;
         end loop;
      end loop;
      
      -- Add the outside of the grid, as all entries are visible here.
      Tree_Count := Tree_Count + Trees.Last_Col + Trees.Last_Col + Trees.Last_Row + Trees.Last_Row - 4;
      return Tree_Count;
   end Count_Visible_Trees;
   
   function Count_Row_Trees( Tree: Tree_T; Trees : Tree_Arr; Start_Idx: Tree_Col_Idx_T; End_Idx: Tree_Col_Idx_T; Row_Idx: Tree_Row_Idx_T ) return Natural is
      Count : Natural := Natural'First;
   begin
      for I in Start_Idx .. End_Idx loop
         -- As soon as we see a bigger tree, exit
         if Trees( Row_Idx, I ) >= Tree then
            exit;
         end if;
         Count := Count + 1;
      end loop;
      return Count;
   end;

   function Count_Col_Trees( Tree: Tree_T; Trees : Tree_Arr; Start_Idx: Tree_Row_Idx_T; End_Idx: Tree_Row_Idx_T; Col_Idx: Tree_Col_Idx_T ) return Natural is
      Count : Natural := Natural'First;
   begin
      for I in Start_Idx .. End_Idx loop
         Count := Count + 1;
         -- As soon as we see a bigger tree, exit
         if Trees( I, Col_Idx ) >= Tree then
            exit;
         end if;
      end loop;
      return Count;
   end;
   
   function Get_Max_Scenic_Score( Trees: Trees_R ) return Natural is
      Max_Score, Scenic_Score: Natural := 0;
      Left, Right, Up,Down: Natural;
   begin
      -- Go for inner squares only, as outside edges will have *0 for view
      for I in Trees.Trees'First(1) + 1 .. Trees.Last_Row - 1 loop
         for J in Trees.Trees'First(2) + 1 .. Trees.Last_Col - 1 loop
            Left := Count_Row_Trees( Trees.Trees(I,J), Trees.Trees, Trees.Trees'First(2), J - 1, I);
            Right := Count_Row_Trees( Trees.Trees(I,J), Trees.Trees, J + 1, Trees.Last_Col, I);
            Up := Count_Col_Trees( Trees.Trees(I,J), Trees.Trees, Trees.Trees'First(1), I - 1, J);
            Down := Count_Col_Trees( Trees.Trees(I,J), Trees.Trees, I + 1, Trees.Last_Row, J);
            
            Scenic_Score := Left * Right * Up * Down;
            
            if Scenic_Score > Max_Score then
               Max_Score := Scenic_Score;
            end if;
         end loop;
      end loop;
      return Max_Score;
   end;

end Days.Day_8;
