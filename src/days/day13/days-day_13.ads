with Ada.Containers.Formal_Vectors;
package Days.Day_13 is
   pragma Elaborate_Body;
   use Ada.Containers;
   
   type Signal_Idx_T is range 1 .. 20;
   
   package  Vec_P is new Formal_Vectors( Index_Type => Signal_Idx_T,
                                         Element_Type => Natural );
   
   type Signal_List_R is record
      -- Vector for signal at this list entry
      Signals: Vec_P.Vector( Count_Type(Signal_Idx_T'Last) );
      -- Depth of list element.
      Depth: Positive;
   end record;
   
   type Signals_R is record
      Left: Signal_List_R;
      Right: Signal_List_R;
   end record;
   
   package Signal_Vec_P is new Formal_Vectors( Index_Type => Signal_Idx_T,
                                               Element_Type => Signals_R);
   
      

end Days.Day_13;
