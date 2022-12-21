with Ada.Containers.Formal_Vectors;
package body Days.Day_13 is
   use Ada.Containers;
   type Signal_Idx_T is range 1 .. 20;
   
   package  Vec_P is new Formal_Vectors( Index_Type => Signal_Idx_T,
                                         Element_Type => Natural );
   type Vec is new Vec_P.Vector( 100 );
   
   package NEsted_Vec_P is new Formal_Vectors( Index_Type => Natural,
                                               Element_Type => Vec );
   type Vec_2 is new NEsted_Vec_P.Vector( 100 );
   package Nested_Nested_Vec_P is new Formal_Vectors( Index_Type => Natural,
                                                      Element_Type => Vec_2 );
   
   -- Can I do a vector of entries of a record type which records the depth of the number.
   -- Can do Vector of entires where they are a record of vector of integers and the depth of the list.
   type Signal_List_R is record
      -- Vector for signal at this list entry
      Singals: Vec_P.Vector( Count_Type(Signal_Idx_T'Last) );
      -- Depth of list element.
      Depth: Positive;
   end record;
   
   package Signal_Vec_P is new Formal_Vectors( Index_Type => Signal_Idx_T,
                                               Element_Type => Signal_List_R);
   
   
   

end Days.Day_13;
