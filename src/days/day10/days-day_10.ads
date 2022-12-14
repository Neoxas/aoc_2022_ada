with Ada.Containers.Formal_Vectors; Use Ada.Containers;

package Days.Day_10 with SPARK_Mode is
   CPU_INST_CAPACITY : constant := 1000;
   
   type Cpu_Inst is (Noop, Addx);
   type Cpu_Inst_Idx_T is range 1 .. CPU_INST_CAPACITY;
   
   type Cpu_Inst_R( Inst: Cpu_Inst := Noop) is record
      case Inst is
         when Addx =>
            Value: Integer;
         when others => null;
      end case;
   end record;

   package Cpu_Inst_Vec_P is new Formal_Vectors( Index_Type => Cpu_Inst_Idx_T,
                                               Element_Type => Cpu_Inst_R );
   
   subtype Cycle_Time_T is Natural range 0 .. 100000;
   type Intersting_Cycles_Arr_T is array( Cycle_Time_T range<> ) of Cycle_Time_T;
   
   subtype Crt_Line_Idx_T is Positive range 1 .. 40;
   subtype Crt_Line_T is String( Crt_Line_Idx_T'First .. Crt_Line_Idx_T'Last );
   type Crt_Screen_Arr_T is array( Cycle_Time_T range<> ) of Crt_Line_T;

   function Get_Sum_Of_Value_At_Interesting_Times( Instructions : Cpu_Inst_Vec_P.Vector; Interesting_Times : Intersting_Cycles_Arr_T ) return Cycle_Time_T;
   function Get_Crt_Screen( Instructions : Cpu_Inst_Vec_P.Vector; Num_Screen_Lines : Positive ) return Crt_Screen_Arr_T;
end Days.Day_10;
