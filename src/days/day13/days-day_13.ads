with Ada.Containers.Formal_Vectors;
package Days.Day_13 is
   pragma Elaborate_Body;
   use Ada.Containers;
   
   type Signal_Idx_T is range 1 .. 20;
   
   package Signals_P is new Formal_Vectors( Index_Type => Signal_Idx_T,
                                         Element_Type => Natural );
   
   type Signal_List_R is record
      -- Vector for signal at this list entry
      Signals: Signals_P.Vector( Count_Type(Signal_Idx_T'Last) );
      -- Depth of list element.
      Depth: Positive;
   end record;
   
   package Signal_Vec_P is new Formal_Vectors( Index_Type => Signal_Idx_T,
                                               Element_Type => Signal_List_R);
   
   type Signals_R is record
      Left: Signal_Vec_P.Vector( Count_Type( Signal_Idx_T'Last ) );
      Right: Signal_Vec_P.Vector( Count_Type( Signal_Idx_T'Last ) );
   end record;
   
   package All_Signals_P is new Formal_Vectors( Index_Type => Signal_Idx_T,
                                                Element_Type => Signals_R );
   
   function Count_Correct_Signals( Signals: All_Signals_P.Vector ) return Natural;

end Days.Day_13;
