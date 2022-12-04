with Ada.Text_IO; use Ada.Text_IO;

package body Days.Day_4 with SPARK_Mode is 
   subtype Clean_Str is Cleaning_Str_P.Bounded_String;
   
   
   procedure Split_String( Str: Clean_Str; Split: String; LHS_Str: out Clean_Str;  RHS_Str: out Clean_Str) is
      Split_Idx : constant Natural := Index( Str, Split);
   begin
      -- -1 to skip taking the index we wanted to split at.
      LHS_Str := Bounded_Slice( Str, 1, Split_Idx - 1 );
      RHS_Str := Bounded_Slice( Str, Split_Idx + 1, Length( Str ));
   end Split_String;
   
   procedure Get_Elves( Str: Clean_Str; Elf_1: out Elf_R; Elf_2: out Elf_R ) is
      function Convert_Str_To_Elf( Str: Clean_Str ) return Elf_R is
         Start: Clean_Str;
         Finish: Clean_Str;
      begin
         Split_String( Str, "-", Start, Finish );
         return ( Start => Natural'Value( To_String(Start) ),
                  Finish => Natural'Value( To_String(Finish) ));
      end Convert_Str_To_Elf;
      Elf_1_Str: Clean_Str;
      Elf_2_Str: Clean_Str;
   begin
      Split_String( Str, ",", Elf_1_Str, Elf_2_Str);
      Elf_1 := Convert_Str_To_Elf( Elf_1_Str); 
      Elf_2 := Convert_Str_To_Elf( Elf_2_Str);
   end Get_Elves;
   
   function Count_Fully_Overlapping_Cleaning( Cleaning_Vec : Cleaning_Vec_P.Vector ) return Natural is
      Elf_1: Elf_R;
      Elf_2: Elf_R;
      Result: Natural := 0;
   begin
      for Cleaning of Cleaning_Vec loop
         Get_Elves( Cleaning, Elf_1, Elf_2 );
         Result := Result + Elf_2.Start + Elf_1.Start;
      end loop;
      return Result;
   end Count_Fully_Overlapping_Cleaning;
   

end Days.Day_4;
