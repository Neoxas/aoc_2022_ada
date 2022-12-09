with Ada.Containers.Formal_Vectors; 
with Ada.Containers.Formal_Indefinite_Vectors; 
use Ada.Containers;
with Ada.Strings.Bounded; use Ada.Strings;

package Days.Day_5 with SPARK_Mode is
   MAX_CONTAINTER_STR : constant := 200;
   MAX_INSTRUCTIONS : constant := 200;
   MAX_STACKS : constant := 20;
   MAX_CRATES : constant := 100;
   
   subtype Crates_T is Character range 'A' .. 'Z';
   subtype Stacks_T is Positive range 1 .. MAX_STACKS;
   
   type Instruction_Idx_T is range 1 .. MAX_INSTRUCTIONS;
   type Instructions_T is record
      From : Positive;
      To : Stacks_T;
      Amount : Stacks_T;
   end record;
   
   package Containter_Str_P is new Ada.Strings.Bounded.Generic_Bounded_Length( MAX_CONTAINTER_STR );
   package Instruction_Str_P is new Ada.Strings.Bounded.Generic_Bounded_Length( MAX_CONTAINTER_STR );
   package Crate_Stack_P is new Formal_Vectors( Index_Type => Positive, 
                                                Element_Type => Crates_T );
   use Crate_Stack_P;
   package Stacks_Vec_P is new Formal_Indefinite_Vectors( Index_Type => Stacks_T, 
                                                          Element_Type => Crate_Stack_P.Vector, 
                                                          Max_Size_In_Storage_Elements => MAX_CRATES * 100 );
   package Instructions_Vec_P is new Formal_Vectors( Index_Type => Instruction_Idx_T,
                                                     Element_Type => Instructions_T );
   
   procedure Process_Crates_Str( Container_Str : Containter_Str_P.Bounded_String; Stacks_Vec : in out Stacks_Vec_P.Vector ); 
   procedure Initialize_Crate_Stacks( Stacks: in out Stacks_Vec_P.Vector );
   function Process_Instruction_Str( Instruction_Str : Instruction_Str_P.Bounded_String) return Instructions_T;
   procedure Execute_Instructions_On_Stacks( Stacks: in out Stacks_Vec_P.Vector; Instructions : Instructions_Vec_P.Vector );
     
end Days.Day_5;
