with Ada.Containers.Formal_Vectors; Use Ada.Containers;
with Ada.Strings.Bounded;
package Days.Day_3 with SPARK_Mode is
   MAX_BACKPACK_SIZE : constant := 1000;
   MAX_CONTENTS_SIZE : constant := 50;
   
   package Contents_Str_P is new Ada.Strings.Bounded.Generic_Bounded_Length( MAX_CONTENTS_SIZE );
   
   use Contents_Str_P;
   package Backpacks_P is new Formal_Vectors (Index_Type   => Positive,
                                              Element_Type => Contents_Str_P.Bounded_String);
   use Backpacks_P;
   function Get_Value_Of_Backpacks( Backpacks : Backpacks_P.Vector ) return Natural with
     Pre => (Length(Backpacks) > 0);
   
   function Get_Value_Of_Groups( Backpacks : Backpacks_P.Vector ) return Natural;

private
   type Compartments_T is record
      Compartment_1 : Contents_Str_P.Bounded_String;
      Compartment_2 : Contents_Str_P.Bounded_String;
   end record;
   
   function Split_Backpack_Contents( Backpack : Contents_Str_P.Bounded_String ) return Compartments_T with
     Pre => ( Length( Backpack ) mod 2 = 0 and Length( Backpack ) > 0),
     Post => (Length(Split_Backpack_Contents'Result.Compartment_1) = Length(Split_Backpack_Contents'Result.Compartment_2));
   
   function Get_Value_Of_Backpack ( Backpack: Contents_Str_P.Bounded_String ) return Natural with
     Pre => ( Length(Backpack) > 0 and Length( Backpack ) mod 2 = 0 );
end Days.Day_3;
