package Days.Day_8 with SPARK_Mode is
   pragma Elaborate_Body;
   
   subtype Tree_Row_Idx_T is Positive range 1 .. 1000;
   subtype Tree_Col_Idx_T is Positive range 1 .. 100;
   
   type Tree_T is range 0 .. 9;
   type Tree_Arr is array( Tree_Row_Idx_T, Tree_Col_Idx_T ) of Tree_T;
   
   type Trees_R is record
      Last_Col: Tree_Col_Idx_T;
      Last_Row: Tree_Row_Idx_T;
      Trees: Tree_Arr;
   end record;
   
   function Count_Visible_Trees( Trees: Trees_R ) return Natural;

end Days.Day_8;
