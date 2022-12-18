package body Days.Day_10 with SPARK_Mode is
   
   subtype Cpu_Times_T is Cycle_Time_T range 1 .. 2;
   
   type Cycle_Lookup_Arr_T is array( Cpu_Inst ) of Cpu_Times_T;
   Cycle_Lookup : constant Cycle_Lookup_Arr_T := ( Noop => 1, Addx => 2 );

   function Get_Sum_Of_Value_At_Interesting_Times( Instructions : Cpu_Inst_Vec_P.Vector; Interesting_Times : Intersting_Cycles_Arr_T ) return Cycle_Time_T is
      Register_Val : Integer := 1;
      Cycle: Cycle_Time_T := 0;
   begin
      return 1;
   end Get_Sum_Of_Value_At_Interesting_Times;

end Days.Day_10;
