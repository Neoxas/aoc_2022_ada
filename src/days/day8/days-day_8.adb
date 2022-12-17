with Ada.Text_IO; use Ada.Text_IO;

package body Days.Day_8 with SPARK_Mode is
   function Is_Row_Visible( Tree: Tree_T; Trees : Tree_Arr; Start_Idx: Tree_Col_Idx_T; End_Idx: Tree_Col_Idx_T; Row_Idx: Tree_Row_Idx_T ) return Boolean is
     (for all J in Start_Idx .. End_Idx => Trees(Row_Idx, J) < Tree);
   function Is_Col_Visible( Tree: Tree_T; Trees : Tree_Arr; Start_Idx: Tree_Row_Idx_T; End_Idx: Tree_Row_Idx_T; Col_Idx: Tree_Col_Idx_T ) return Boolean is
     (for all J in Start_Idx .. End_Idx => Trees(J, Col_Idx) < Tree);
   
   function Count_Visible_Trees( Trees: Trees_R ) return Natural is
      Tree_Count: Natural := Natural'First;
   begin
      for I in Trees.Trees'First(1) + 1 .. Trees.Last_Row - 1 loop
         for J in Trees.Trees'First(2) + 1 .. Trees.Last_Col - 1 loop
            Put_Line( "Row: " & I'Image & ", Col: " & J'Image & ", Tree: " & Trees.Trees(I,J)'Image);
            if Is_Row_Visible( Trees.Trees(I,J), Trees.Trees, J - 1, Trees.Trees'First(2), I) or 
              Is_Row_Visible( Trees.Trees(I,J), Trees.Trees, J + 1, Trees.Last_Col, I) or 
              Is_Col_Visible( Trees.Trees(I,J), Trees.Trees, I - 1, Trees.Trees'First(1), J) or
              Is_Col_Visible( Trees.Trees(I,J), Trees.Trees, I + 1, Trees.Last_Row, J)
            then
               Put_Line( "Visible" );
               Tree_Count := Tree_Count + 1;
            else
               Put_Line( "Not Visible" );
            end if;
         end loop;
      end loop;
      return Tree_Count;
   end Count_Visible_Trees;

end Days.Day_8;
