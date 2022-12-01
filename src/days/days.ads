with Ada.Containers.Vectors;
package Days is
    package Nat_Vec is new
      Ada.Containers.Vectors( Index_Type => Natural, Element_Type => Natural );

    procedure Run_Day_1( Input_File: String );
    procedure Run_Day_2( Input_File: String );
end Days;
