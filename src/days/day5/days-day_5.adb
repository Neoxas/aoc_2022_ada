with Ada.Text_IO; use Ada.Text_IO;
package body Days.Day_5 with SPARK_Mode is
	use Containter_Str_P;
   use Stacks_Vec_P;
   
   procedure Add_Crate_To_Stack( Crate : Crates_T; Stack: in out Crate_Stack_P.Vector ) is
   begin
      Insert( Stack, 1, Crate );
   end Add_Crate_To_Stack;

   procedure Process_Crates_Str( Container_Str : Containter_Str_P.Bounded_String; Stacks_Vec : in out Stacks_Vec_P.Vector ) is
   begin
      Put_Line( To_String( Container_Str ) );
      for Char_Idx in 1 .. Length(Container_Str) loop
         if Element(Container_Str, Char_Idx ) in Crates_T then
            declare 
               -- Stack : Crate_Stack_P.Vector := Element( Stacks_Vec, (Char_Idx + 2)/4 );
            begin             
               Put_Line( Element( Container_Str, Char_Idx )'Image );
               -- Insert( Stack, 1, Element( Container_Str, Char_Idx ) );
               -- THIS IS NOT MAINTINING THE STACK REFERENCE BETWEEN THESE ENTRIES
               -- Append( Stack, Element( Container_Str, Char_Idx ) );
               Add_Crate_To_Stack( Element( Container_Str, Char_Idx), Element( Stacks_Vec, (Char_Idx + 2 )/4));
               --  for I in First_Index( Stack ) .. Last_Index( Stack ) loop
               --     Put_Line( Element( Stack, I )'Image );
               --  end loop;
            end;
         end if;
      end loop;
   end Process_Crates_Str;	

   procedure Initialize_Crate_Stacks( Stacks: in out Stacks_Vec_P.Vector ) is
   begin
      -- Initilize all crate stacks
      for I in Stacks_T'Range loop
         declare
            Crate_Stack : Crate_Stack_P.Vector( MAX_CRATES );
         begin
            Append(Stacks, Crate_Stack );
         end;
      end loop;
   end Initialize_Crate_Stacks;
end Days.Day_5;
