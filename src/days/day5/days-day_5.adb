with Ada.Text_IO; use Ada.Text_IO;
package body Days.Day_5 with SPARK_Mode is
	use Containter_Str_P;
   use Stacks_Vec_P;
   use Instruction_Str_P;
   
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
   
   function Process_Instruction_Str( Instruction_Str : Instruction_Str_P.Bounded_String) return Instructions_T is
      Spaces : constant Positive := Instruction_Str_P.Count( Instruction_Str, " ");
      type Instruction_Arr_T is array( 1 .. Spaces + 1 ) of Instruction_Str_P.Bounded_String;
      
      function Split_String( Instruction_Str : Instruction_Str_P.Bounded_String ) return Instruction_Arr_T is
         Space_Idx : Natural := Instruction_Str_P.Index( Instruction_Str, " ");
         Current_Idx : Natural := 1;
         Slice: Instruction_Str_P.Bounded_String;
         Inst_Arr : Instruction_Arr_T := ( others => To_Bounded_String("") );
      begin
         -- Want to stop one before the end to capture end of string
         for Space in Inst_Arr'First .. Inst_Arr'Last - 1 loop
            -- Find where space is located
            Space_Idx := Instruction_Str_P.Index( Instruction_Str, " ", Current_Idx);
            -- Get slice. Added trimmed entry to instruction array
            Slice := Instruction_Str_P.Bounded_Slice( Source => Instruction_Str, Low => Current_Idx, High => Space_Idx );
            Inst_Arr( Space ) := Trim( Slice, Both );
            
            Current_Idx := Space_Idx + 1;
         end loop;
         -- Get last entry
         Slice := Instruction_Str_P.Bounded_Slice( Source => Instruction_Str, Low => Current_Idx, High => Length( Instruction_Str ) );
         Inst_Arr( Inst_Arr'Last ) := Trim( Slice, Both );
         return Inst_Arr;
      end Split_String;
      Inst_Arr : constant Instruction_Arr_T := Split_String( Instruction_Str );
      Instruction : Instructions_T := ( 1, 1, 1 );
   begin
      -- This is likely horribly in-efficient and messy but it works.
      for I in Inst_Arr'Range loop
         if Inst_Arr( I ) = "move" then 
            Instruction.Amount := Positive'Value( To_String(Inst_Arr( I + 1 )));
         elsif Inst_Arr( I ) = "from" then
            Instruction.From := Stacks_T'Value( To_String(Inst_Arr( I + 1 )));
         elsif Inst_Arr( I ) = "to" then
            Instruction.To := Stacks_T'Value( To_String(Inst_Arr( I + 1 )));
         end if;
      end loop;
      return Instruction;
   end Process_Instruction_Str;

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
   
   procedure Execute_Instructions_On_Stacks( Stacks: in out Stacks_Vec_P.Vector; Instructions : Instructions_Vec_P.Vector ) is
   begin
      for Inst_Idx in Instructions_Vec_P.First_Index( Instructions ) .. Instructions_Vec_P.Last_Index( Instructions ) loop
         declare 
            Instruction : constant Instructions_T := Instructions_Vec_P.Element( Instructions, Inst_Idx );
         begin
            for I in 1 .. Instruction.Amount loop
               declare
                  From_Stack: Crate_Stack_P.Vector := Element( Stacks, Instruction.From );
                  To_Stack: Crate_Stack_P.Vector := Element( Stacks, Instruction.To );
                  Tmp : constant Crates_T := Last_Element( From_Stack );
               begin
                  Delete_Last( From_Stack );
                  Append( To_Stack, Tmp );
                  Replace_Element( Stacks, Instruction.From, From_Stack );
                  Replace_Element( Stacks, Instruction.To, To_Stack );
               end;
            end loop;
         end;
      end loop;
   end Execute_Instructions_On_Stacks;
end Days.Day_5;
