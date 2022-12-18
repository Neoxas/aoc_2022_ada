package body Days.Day_10 with SPARK_Mode is
   
   subtype Cpu_Times_T is Cycle_Time_T range 1 .. 2;
   
   type Cycle_Lookup_Arr_T is array( Cpu_Inst ) of Cpu_Times_T;
   Cycle_Lookup : constant Cycle_Lookup_Arr_T := ( Noop => 1, Addx => 2 );

   function Cycle_In_Interesting( Cycle: Cycle_Time_T; Insteresting: Intersting_Cycles_Arr_T ) return Boolean is
      ( for some J in Insteresting'Range => Insteresting( J ) = Cycle );
   
   function Get_Sum_Of_Value_At_Interesting_Times( Instructions : Cpu_Inst_Vec_P.Vector; Interesting_Times : Intersting_Cycles_Arr_T ) return Cycle_Time_T is
      Val_Sum : Cycle_Time_T := 0;
      Register_Val : Integer := 1;
      Cycle: Cycle_Time_T := 0;
      Exec_Time : Cpu_Times_T; 
   begin
      for Inst of Instructions loop
         Exec_Time := Cycle_Lookup( Inst.Inst );
         
         -- For however many cycles we require, wait that many loops
         for I in Cpu_Times_T'First .. Exec_Time loop
            Cycle := Cycle + 1;
            
            -- If we land on an interesting cycle time. Add it to the results.
            if Cycle_In_Interesting( Cycle, Interesting_Times) then
               Val_Sum := Val_Sum + (Register_Val * Cycle );
            end if;
         end loop;
         
         -- At end of cycle, execute instruction
         case Inst.Inst is
            when Addx => 
               Register_Val := Register_Val + Inst.Value;
            when others => null;
         end case;
      end loop;
      
      return Val_Sum;
   end Get_Sum_Of_Value_At_Interesting_Times;

   function Get_Crt_Screen( Instructions : Cpu_Inst_Vec_P.Vector; Num_Screen_Lines : Positive ) return Crt_Screen_Arr_T is
      -- Initialize screen with error values if cell not written.
      Crt_Screen : Crt_Screen_Arr_T( 1 .. Num_Screen_Lines ) := ( others => (others => 'E' ) );
      Screen_Row_Idx : Positive := Crt_Screen'First;
      Pixel_Idx : Crt_Line_Idx_T := Crt_Line_Idx_T'First;
      Register_Val : Integer := 1;
      Exec_Time : Cpu_Times_T;
   begin
      for Inst of Instructions loop
         Exec_Time := Cycle_Lookup( Inst.Inst );
         
         
         -- For however many cycles we require, wait that many loops
         for I in Cpu_Times_T'First .. Exec_Time loop
            -- Draw Pixel. If we overlap, add a #, else draw a .
            if Pixel_Idx - 1 in Register_Val - 1 .. Register_Val + 1 then
               Crt_Screen( Screen_Row_Idx )(Pixel_Idx) := '#';
            else
               Crt_Screen( Screen_Row_Idx )(Pixel_Idx) := '.';
            end if;

            -- If we on the last pixel, we need to increment our row and reset pixel value
            if (Pixel_Idx = Crt_Line_Idx_T'Last) then
               Screen_Row_Idx := Screen_Row_Idx + 1;
               Pixel_Idx := Crt_Line_Idx_T'First;
            else
               Pixel_Idx := Pixel_Idx + 1;
            end if;
         end loop;
         
         -- At end of cycle, execute instruction
         case Inst.Inst is
            when Addx => 
               Register_Val := Register_Val + Inst.Value;
            when others => null;
         end case;
      end loop;

      return Crt_Screen;
   end Get_Crt_Screen;
end Days.Day_10;
