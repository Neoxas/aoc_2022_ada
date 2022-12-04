with Ada.Containers.Formal_Vectors; Use Ada.Containers;
with Ada.Strings.Bounded;
package Days.Day_4 with SPARK_Mode is

   MAX_CLEANING_STRING_LEN : constant := 50;
   MAX_CLEANING_VEC_SIZE : constant := 1000;
   package Cleaning_Str_P is new Ada.Strings.Bounded.Generic_Bounded_Length( MAX_CLEANING_STRING_LEN );
   use Cleaning_Str_P;
   
   package Cleaning_Vec_P is new Formal_Vectors(Index_Type   => Positive,
                                              Element_Type => Cleaning_Str_P.Bounded_String);
   use Cleaning_Vec_P;
   
   function Count_Fully_Overlapping_Cleaning( Cleaning_Vec : Cleaning_Vec_P.Vector ) return Natural;
private
   type Elf_R is record
      Start : Natural;
      Finish : Natural;
   end record with 
     Predicate => ( Finish > Start );
end Days.Day_4;
