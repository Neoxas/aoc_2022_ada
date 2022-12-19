with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;
with Ada.Containers.Vectors;
with Ada.Strings;
with Ada.Strings.Maps;
with Ada.Strings.Maps.Constants;
with Ada.Numerics.Big_Numbers.Big_Integers;
with Utilities;
with Days.Day_1;
with Days.Day_2;
with Days.Day_3;
with Days.Day_4;
with Days.Day_5;
with Days.Day_6;
with Days.Day_8;
with Days.Day_9; 
with Days.Day_10;
with Days.Day_11;
with Days.Day_12;

package body Days is
    
    procedure Run_Day_1( Input_File: String ) is
      use Days.Day_1;
      package Nat_Vec is new
        Ada.Containers.Vectors( Index_Type => Natural, Element_Type => Natural );
        function Get_Calories_From_File( Input_File: String ) return Calories_Arr_T is
            -- Gets a Vector containing each elf with the relevant calories
            -- Each Elf in the input file is seperated by a blank line
            function Convert_Vec_To_Arr( Vec : Nat_Vec.Vector ) return Calories_Arr_T is
                Arr : Calories_Arr_T( Natural'First .. Natural(Vec.Length) ) := ( others => Positive'First );
            begin
                for Idx in Vec.First_Index .. Vec.Last_Index loop
                    Arr(Idx) := Vec(Idx);
                end loop;
                return Arr;
            end Convert_Vec_To_Arr;
            
            File : File_Type;
            Vec : Nat_Vec.Vector;
            Curr_Elf : Natural := Natural'First;
        begin
            Open(File => File, Mode => In_File, Name => Input_File);
        
            while (not End_Of_File(File) ) loop
                declare
                    Line : constant String := Get_Line(File => File);
                begin
                    if Line /= "" then -- Entries are split by a blank line
                        Curr_Elf := Curr_Elf + Natural'Value( Line );
                    else
                        Vec.Append( Curr_Elf );
                        Curr_Elf := Natural'First;
                    end if;
                end;
            end loop;
            -- Account for file not ending on a blank line
            Vec.Append( Curr_Elf );
        
            Close(File => File);
        
            return Convert_Vec_To_Arr(Vec);
        end Get_Calories_From_File;
        Arr: constant Calories_Arr_T := Get_Calories_From_File( Input_File );
    begin
        Put_Line( "--- Day 1 ---" );
        Put_Line( "Part 1");
        Put_Line( "Max Elf Calories: " & Get_Max_Elf_Calories( Arr )'Image );
        Put_Line( "Part 2");
        Put_Line( "Total Calories of top 3 Elves: " & Get_Total_Calories_Of_Top_X_Elves( Arr, 3 )'Image );
    end Run_Day_1;
    
    procedure Run_Day_2( Input_File: String ) is
      use Days.Day_2;
        procedure Get_Rounds( Input_File: String; Arr_Len : out Round_Count_T; Matched_Round : out Rounds_T; Predicted_Rounds: out Rounds_T  ) is
            -- TODO: Work out better way of initalizing this
            File : File_Type;
        begin
            Arr_Len := Round_Count_T'First;
            
            Open( File, In_File, Input_File ); 
            
            while not End_Of_File( File ) loop
                declare
                    Line : constant Round_Str_T := Get_Line( File )( 1 .. 3 );
                begin
                    Matched_Round( Arr_Len ) := Convert_To_Matched_Round( Line );
                    Predicted_Rounds( Arr_Len ) := Convert_To_Predicted_Round( Line );
                    Arr_Len := Arr_Len + 1;
                end;
            end loop;
            -- Remove final loop addition
            Arr_Len := Arr_Len - 1;
            Close(File);
        end Get_Rounds;
        
        Rounds_Count : Round_Count_T;
        Matched_Rounds : Rounds_T ;
        Predicted_Rounds : Rounds_T;
    begin
        Get_Rounds( Input_File, Rounds_Count, Matched_Rounds, Predicted_Rounds );
        
        Put_Line( "--- Day 2 ---" );
        Put_Line( "Part 1");
        Put_Line( "Matched Rounds Score: " & Get_Guide_Score(Matched_Rounds, Rounds_Count)'Image );
        Put_Line( "Part 2");
        Put_Line( "Predicted Rounds Score: " & Get_Guide_Score(Predicted_Rounds, Rounds_Count)'Image );
   end Run_Day_2;
   
   procedure Run_Day_3( Input_File: String ) is
      use Days.Day_3;
      use Backpacks_P;
      use Contents_Str_P;
      function Get_Backpacks( Input_File: String ) return Backpacks_P.Vector is
         File : File_Type;
         Backpacks : Backpacks_P.Vector( MAX_BACKPACK_SIZE );
      begin
         Open( File, In_File, Input_File );
         
         while not End_Of_File( File ) loop
            declare
               Line : constant Contents_Str_P.Bounded_String := To_Bounded_String( Get_Line( File ));
            begin
               Append( Backpacks, Line );
            end ;
         end loop;
         
         Close( File );
         
         return Backpacks;
      end Get_Backpacks;
      
      Backpacks : constant Backpacks_P.Vector := Get_Backpacks( Input_File );
      Duplicates : constant Natural := Get_Value_Of_Backpacks( Backpacks );
      Memberships : constant Natural := Get_Value_Of_Groups( Backpacks );
   begin
      Put_Line( "--- Day 3 ---" );
      Put_Line( "Part 1" );
      Put_Line( "Value of backpack duplicates : " & Duplicates'Image );
      Put_Line( "Part 2" );
      Put_Line( "Value of group memberships : " & Memberships'Image );
   end Run_Day_3;
   
   procedure Run_Day_4( Input_File: String ) is
      use Days.Day_4;
      use Cleaning_Str_P;
      use Cleaning_Vec_P;
      
      function Get_Cleaning_Vec( Input_File: String ) return Cleaning_Vec_P.Vector is
         File: File_Type;
         Cleaning_Vec : Cleaning_Vec_P.Vector(MAX_CLEANING_VEC_SIZE);
      begin
         Open( File, In_File, Input_File );
         
         while not End_Of_File( File ) loop
            Append( Cleaning_Vec, To_Bounded_String( Get_Line( File ) ) );
         end loop;
         
         Close(File);
         return Cleaning_Vec;
      end Get_Cleaning_Vec;
      Cleaning_Vec : constant Cleaning_Vec_P.Vector := Get_Cleaning_Vec( Input_File );
      Fully_Overlap: constant Natural := Count_Fully_Overlapping_Cleaning( Cleaning_Vec );
      Partly_Overlap: constant Natural := Count_Partly_Overlapping_Cleaning( Cleaning_Vec );
   begin
      Put_Line( "--- Day 4 ---" );
      Put_Line( "Part 1" );
      Put_Line( "Count of fully overlapping : " & Fully_Overlap'Image );
      Put_Line( "Part 2" );
      Put_Line( "Count of partly overlapping : " & Partly_Overlap'Image );
   end Run_Day_4;
   
   procedure Run_Day_5( Input_File: String ) is
      use Days.Day_5;
      use Containter_Str_P;
      use Instruction_Str_P;
      use Crate_Stack_P;
      use Stacks_Vec_P;
      use Instructions_Vec_P;
      Stacks : Stacks_Vec_P.Vector(MAX_STACKS);
      Stacks_2 : Stacks_Vec_P.Vector( MAX_STACKS );
      Instructions : Instructions_Vec_P.Vector(MAX_INSTRUCTIONS);
      File: File_Type;
   begin
      Initialize_Crate_Stacks(Stacks);
      Initialize_Crate_Stacks(Stacks_2);
      
      Put_Line( "--- Day 5 ---" );
      Put_Line( "Part 1" );
      
      Open( File, In_File, Input_File);
      while not End_Of_File( File ) loop
         declare
            Line : constant Containter_Str_P.Bounded_String := To_Bounded_String(Get_Line( File ));
         begin
            -- An empty line is what defines the gap between crates and instructions.
            if Line /= "" then
               Process_Crates_Str( Line, Stacks );
               Process_Crates_Str( Line, Stacks_2 );
            else
               exit;
            end if;
         end;
      end loop;
      
      -- All remaining entries are instructions
      while not End_Of_File( File ) loop
         declare
            Instruction : constant Instructions_T := Process_Instruction_Str( To_Bounded_String( Get_Line( File ) ) );
         begin
            Append( Instructions, Instruction );
         end;
      end loop;
      
      Close( File );
      
      -- Execute normal instructions on stack
      Mover_9000_Instructions_On_Stacks( Stacks, Instructions );
      For I in First_Index( Stacks ) .. Last_Index( Stacks ) loop
         declare
            Stack : constant Crate_Stack_P.Vector := Element( Stacks, I );
         begin
            if not Is_Empty( Stack ) then
               Put( Last_Element( Stack ) );
            end if;
         end;
      end loop;
      
      Put_Line("");
      Put_Line( "Part 2");
      
      Mover_9001_Instructions_On_Stacks( Stacks_2, Instructions );
      For I in First_Index( Stacks_2 ) .. Last_Index( Stacks_2 ) loop
         declare
            Stack : constant Crate_Stack_P.Vector := Element( Stacks_2, I );
         begin
            if not Is_Empty( Stack ) then
               Put( Last_Element( Stack ) );
            end if;
         end;
      end loop;
   end Run_Day_5;
   
   procedure Run_Day_6( Input_File: String ) is
      use Days.Day_6;
      use Search_Str_P;
      function Get_Search_String( Input_File: String ) return Search_Str_P.Bounded_String is
         File: File_Type;
         Str: Search_Str_P.Bounded_String;
      begin
         Open( File, In_File, Input_File );
         
         while not End_Of_File( File ) loop
            Str := Str & Get_Line( File );
         end loop;
         
         Close(File);
         return Str;
      end Get_Search_String;

      Str : constant Search_Str_P.Bounded_String := Get_Search_String( Input_File );
      Packet_Idx : constant Window_Size_T := Find_First_Non_Overlap( Str, 4 );
      Message_Idx : constant Window_Size_T := Find_First_Non_Overlap( Str, 14 );
   begin
      Put_Line( "--- Day 6 ---" );
      Put_Line( "Part 1" );
      Put_Line( "Idx of Start of Packet Marker : " & Packet_Idx'Image );
      Put_Line( "Part 2" );
      Put_Line( "Idx of Start of Message Marker : " & Message_Idx'Image );
   end Run_Day_6;
   
   procedure Run_Day_8( Input_File: String ) is
      use Days.Day_8;
      function Build_Trees( Input_File: String ) return Trees_R is
         Trees : Trees_R;
         Tree_Col_Idx : Tree_Col_Idx_T := Tree_Col_Idx_T'First;
         Tree_Row_Idx : Tree_Row_Idx_T := Tree_Row_Idx_T'First;
         File: File_Type;
      begin
         Open( File, In_File, Input_File);
         
         while not End_Of_File( File ) loop
            Tree_Col_Idx := Tree_Col_Idx_T'First;
            declare
               Line: constant String := Get_Line( File );
            begin
               for Tree of Line loop
                  -- Convert Chr to string by making it an array.
                  Trees.Trees(Tree_Row_Idx, Tree_Col_Idx) := Tree_T'Value((1 => Tree));
                  Tree_Col_Idx := Tree_Col_Idx + 1;
               end loop;
            end;
            Tree_Row_Idx := Tree_Row_Idx + 1;
         end loop;
         
         Close(File);
         
         -- Remove extra addition of row/col
         Trees.Last_Col := Tree_Col_Idx - 1;
         Trees.Last_Row := Tree_Row_Idx - 1;
         return Trees;
      end Build_Trees;
      
      Trees: constant Trees_R := Build_Trees( Input_File );
      Visible_Trees: constant Natural := Count_Visible_Trees( Trees );
      Scenic_Score: constant Natural := Get_Max_Scenic_Score( Trees );
   begin
      Put_Line( "--- Day 8 ---" );
      Put_Line( "Part 1" );    
      Put_Line( "Number of visible trees: " & Visible_Trees'Image );
      Put_Line( "Part 2" );    
      Put_Line( "Scenic score: " & Scenic_Score'Image );
   end Run_Day_8;

   procedure Run_Day_9( Input_File: String ) is
      use Days.Day_9;
      use Rope_Inst_Vec_P;
      use Ada.Strings.Fixed;
      function Get_Rope_Instructions( Input_File: String ) return Rope_Inst_Vec_P.Vector is
         Inst_Vec : Rope_Inst_Vec_P.Vector(MAX_ROPE_INST);
         File: File_Type;
      begin
         Open( File, In_File, Input_File);
         
         while not End_Of_File( File ) loop
            declare
               Line : constant String := Get_Line( File );
               -- Find where the string is split
               Space_Idx : constant Natural := Index( Line, " " );
               Instruction : constant Rope_Inst_R := (
                                             Dir => Rope_Dir'Value( Line(Line'First .. Space_Idx ) ),
                                             Dist => Rope_Dist_T'Value( Line( Space_Idx + 1 .. Line'Last )));
            begin
               Append( Inst_Vec, Instruction );
            end;
         end loop;
         
         Close(File);
         
         return Inst_Vec;
      end Get_Rope_Instructions;
      
      Instructions : constant Rope_Inst_Vec_P.Vector := Get_Rope_Instructions(Input_File);
      Single_Knot_Visited_Spaces: constant Natural := Count_Single_Knot_Visited_Spaces(Instructions => Instructions);
      Ten_Knot_Visited_Spaces: constant Natural := Count_X_Knot_Visited_Spaces(Instructions => Instructions, Knots => 10);
   begin
      Put_Line( "--- Day 9 ---" );
      Put_Line( "Part 1" );
      Put_Line( "Single Knot Visited Spaces: " & Single_Knot_Visited_Spaces'Image );
      Put_Line( "Part 2" );
      Put_Line( "Ten Knot Visited Spaces: " & Ten_Knot_Visited_Spaces'Image );
   end Run_Day_9;

   procedure Run_Day_10( Input_File: String ) is
      use Days.Day_10;
      use Cpu_Inst_Vec_P;
      use Ada.Strings.Fixed;
      function Get_Cpu_Instructions( Input_File: String ) return Cpu_Inst_Vec_P.Vector is
         Vec : Cpu_Inst_Vec_P.Vector(CPU_INST_CAPACITY);
         File : File_Type;
      begin
         Open( File, In_File, Input_File );
         
         while not End_Of_File( File ) loop
            declare
               Line : constant String := Get_Line( File );
               Space_Idx : constant Natural := Index( Line, " " );
               Inst : Cpu_Inst_R;
            begin
               if Space_Idx = 0 then
                  Inst := ( Inst => Noop);
               else
                  Inst := ( Inst => Addx,
                            Value => Integer'Value( Line( Space_Idx + 1 .. Line'Last ) ) );
               end if;
               Append( Vec, Inst );
            end;
         end loop;
         
         Close( File );
         
         return Vec;
      end Get_Cpu_Instructions;
      
      Cpu_Insts : constant Cpu_Inst_Vec_P.Vector := Get_Cpu_Instructions( Input_File );
      Intersting_Times : constant Intersting_Cycles_Arr_T( 1 .. 6 ) := ( 20, 60,100,140,180,220 );
      Sum_Times: constant Cycle_Time_T := Get_Sum_Of_Value_At_Interesting_Times( Cpu_Insts, Intersting_Times);
      Crt_Scren : constant Crt_Screen_Arr_T := Get_Crt_Screen( Cpu_Insts, 6);
   begin
      Put_Line( "--- Day 10 ---" );
      Put_Line( "Part 1" );
      Put_Line( "Sum of interesting times: " & Sum_Times'Image );
      Put_Line( "Part 2" );
      for Line of Crt_Scren loop
         Put_Line( Line );
      end loop;
   end Run_Day_10;

   procedure Run_Day_11( Input_File: String ) is
      use Days.Day_11;
      use Ada.Strings;
      use Ada.Strings.Maps;
      use Ada.Strings.Maps.Constants;
      use Monkey_Map_P;
      use Monkey_Item_Vec_P;
      use Utilities;
      use Utilities.Split_Str_P;
      use Ada.Numerics.Big_Numbers.Big_Integers;
      function Get_Monkeys( Input_File: String ) return Monkey_Map_P.Map is
         File : File_Type;
         -- TODO: Lookup modulus
         Monkeys : Monkey_Map_P.Map( MONKEY_CAP, 92821 );
         function Trim_File_Line( File: in out File_Type ) return String is
         begin
            return Split_Str_P.To_String( 
                                          Split_Str_P.Trim( 
                                            Source => Split_Str_P.To_Bounded_String(Get_Line( File )),
                                            Side => Both));
         end Trim_File_Line;
         
         function Trim_To_Number( Str: Split_Str_P.Bounded_String ) return Split_Str_P.Bounded_String is
         begin
            return Split_Str_P.Trim( Source => Str,
                                     Left => not Decimal_Digit_Set,
                                     Right => not Decimal_Digit_Set );
         end Trim_To_Number;

         function Trim_To_Number( Str: String ) return Split_Str_P.Bounded_String is
         begin
            return Trim_To_Number( Split_Str_P.To_Bounded_String( Str ) );
         end Trim_To_Number;

         function Process_Monkey( File: in out File_Type ) return Monkey_R is

            function Process_Items( Items_Str: String ) return Monkey_Item_Vec_P.Vector is
               Split_Str: constant Split_Str_Arr := Split_String( Items_Str, " " );
               Items : Monkey_Item_Vec_P.Vector(MONKEY_ITEM_CAP);
            begin
               -- Skip first two elements in string
               for Item_Idx in Split_Str'First + 2 .. Split_Str'Last loop
                  declare
                     Trimmed : constant Split_Str_P.Bounded_String := Trim_To_Number( Split_Str( Item_Idx ) );
                  begin
                     Append( Items, Convert_String_To_Worry( Split_Str_P.To_String(Trimmed)) );
                  end;
               end loop;
               return Items;
            end Process_Items;
            
            function Process_Worry_Op( Worry_Str: String ) return Worry_Op_R is
               function Get_Worry_Type( Str: Split_Str_P.Bounded_String ) return Worry_Side_R is
               begin
                  if Str = "old" then
                  return (Side_Type => Old);
               else
                  return (Side_Type => Value, Side_Val => Convert_String_To_Worry( To_String(Trim_To_Number( Str ))));
               end if;
               end Get_Worry_Type;

               Worry_Split: constant Split_Str_Arr := Split_String( Worry_Str, " " );
               LHS_Str: constant Bounded_String := Trim(Worry_Split( 3 ), Both);
               Op_Str: constant Bounded_String := Trim(Worry_Split( 4 ), Both);
               RHS_Str: constant Bounded_String := Trim(Worry_Split( 5 ), Both);
               Worry_Op : Worry_Op_R;
            begin
               Worry_Op.LHS_Type := Get_Worry_Type( LHS_Str );
               -- Convert To character, then back to a string to make to enum
               Worry_Op.Operator := Monkey_Op_E'Value( ( Element(Op_Str, 1)'Image ));
               Worry_Op.RHS_Type := Get_Worry_Type( RHS_Str );
               return Worry_Op;
            end Process_Worry_Op;
            
            function Process_Div( Div_Str: String ) return Big_Positive is
            begin
               return From_String( Split_Str_P.To_String( Trim_To_Number( Div_Str ) ) );
            end Process_Div;

            function Process_Result_Monkey( Throw_Str: String ) return Monkey_ID_T is
            begin
               return Monkey_ID_T'Value(Split_Str_P.To_String( Trim_To_Number( Throw_Str ) ));
            end Process_Result_Monkey;

            Items : constant Monkey_Item_Vec_P.Vector := Process_Items( Trim_File_Line( File ) );
            Item_Op: constant Worry_Op_R := Process_Worry_Op( Trim_File_Line( File ) );
            Division: constant Big_Positive := Process_Div( Trim_File_Line( File ) );
            Pass_Monkey : constant Monkey_ID_T := Process_Result_Monkey( Trim_File_Line( File ) );
            Fail_Monkey : constant Monkey_ID_T := Process_Result_Monkey( Trim_File_Line( File ) );
         begin

            return (Items => Items, 
                    Item_Op => Item_Op, 
                    Div_Test => Division, 
                    Pass_Monkey => Pass_Monkey, 
                    Fail_Monkey => Fail_Monkey,
                    Items_Inspected => 0);
         end Process_Monkey;
      begin
         Open( File, In_File, Input_File );
         
         while not End_Of_File( File )loop
            declare 
               -- Trim down to just the ID number
               Monkey_ID : constant Monkey_ID_T := Monkey_ID_T'Value( Split_Str_P.To_String( Trim_To_Number( Trim_File_Line( File ) ) ) );
            begin
               Insert( Monkeys, Monkey_ID, Process_Monkey( File ));
            end;
            
            if not End_Of_File( File ) then
               Skip_Line( File );
            end if;
         end loop;

         Close( File );
         return Monkeys;
      end Get_Monkeys;

      Monkeys : constant Monkey_Map_P.Map := Get_Monkeys( Input_File );
      Monkey_Buisness_1: constant Natural := Get_Monkey_Buisness_Level( Monkeys => Monkeys, Rounds => 20, Relief => True );
      Monkey_Buisness_2: constant Natural := Get_Monkey_Buisness_Level( Monkeys => Monkeys, Rounds => 10000, Relief => False );
   begin
      Put_Line( "--- Day 11 ---" );
      Put_Line( "Part 1" );
      Put_Line( "Level of monkey buisness with relief: " & Monkey_Buisness_1'Image );
      Put_Line( "Part 2" );
      Put_Line( "Level of monkey buisness without relief: " & Monkey_Buisness_2'Image );
   end Run_Day_11;
   
   procedure Run_Day_12( Input_File: String ) is
      use Day_12;
      use Utilities;
      function Get_Map( Input_File: String ) return Map_Arr is
         FS : constant File_Structure_R := Get_File_Structure( Input_File );
         File : File_Type;
         Map: Map_Arr( Map_Idx'First .. Map_Idx(FS.Num_Lines), Map_Idx'First .. Map_Idx(FS.Line_Length));
         Row_Idx : Map_Idx := Map_Idx'First;
      begin
         Open( File, In_File, Input_File );

         while not End_Of_FIle( File ) loop
            declare
               Line: constant String := Get_Line( File );
            begin
               for I in Line'First .. Line'Last loop
                  Map( Row_Idx, Map_Idx(I) ) := Line( I );
               end loop;
            end;
            Row_Idx := Row_Idx + 1;
         end loop;

         Close(File);

         return Map;
      end Get_Map;
      
      Map: constant Map_Arr := Get_Map( Input_File );
   begin
      Put_Line( "--- Day 12 ---" );
      Put_Line( "Part 1" );
      for Row_Idx in Map'Range( 1 ) loop
         for Col_Idx in Map'Range( 2 ) loop
            Put( Map( Row_Idx, Col_Idx )'Image );
         end loop;
         Put_Line( "" );
      end loop;
   end Run_Day_12;
end Days;
