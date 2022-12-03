with Ada.Containers.Formal_Vectors; Use Ada.Containers;
with Ada.Strings.Bounded;
package Days.Day_3 with SPARK_Mode is
   MAX_BACKPACK_SIZE : constant := 1000;
   MAX_CONTENTS_SIZE : constant := 50;
   
   package Contents_Str_P is new Ada.Strings.Bounded.Generic_Bounded_Length( MAX_CONTENTS_SIZE );
   
   use Contents_Str_P;
   package Backpacks_P is new Formal_Vectors (Index_Type   => Positive,
                                              Element_Type => Contents_Str_P.Bounded_String);
   
   function Get_Value_Of_Backpacks( Backpacks : Backpacks_P.Vector ) return Natural;

end Days.Day_3;
