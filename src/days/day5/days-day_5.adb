with Ada.Text_IO; use Ada.Text_IO;
package body Days.Day_5 with SPARK_Mode is
	use Containter_Str_P;
   use Stacks_Vec_P;
   
   procedure Process_Crates_Str( Container_Str : Containter_Str_P.Bounded_String; Stacks_Vec : in out Stacks_Vec_P.Vector ) is
   begin
      Put_Line( To_String( Container_Str ) );
      for Char_Idx in 1 .. Length(Container_Str) loop
         if Element(Container_Str, Char_Idx ) in Crates_T then
            declare 
               Stack_Idx: constant Stacks_T := (Char_Idx + 2 )/4;
               Stack : Crate_Stack_P.Vector := Element( Stacks_Vec, Stack_Idx );
            begin             
               -- Insert at the start to ensure we keep them in the correct order.
               Insert( Stack, 1, Element( Container_Str, Char_Idx ) );
               -- We now have to replace the vector we have stored with the updated entry.
               Replace_Element( Stacks_Vec, Stack_Idx, Stack );
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
