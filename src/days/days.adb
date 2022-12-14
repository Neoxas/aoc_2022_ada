with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;
with Ada.Containers.Vectors;
with Ada.Containers.Formal_Vectors;
with Ada.Strings;
with Ada.Strings.Bounded;
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
with Days.Day_13;
with Days.Day_14;

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
      function Get_Map( Input_File: String ) return Map_Arr_T is
         FS : constant File_Structure_R := Get_File_Structure( Input_File );
         File : File_Type;
         Map: Map_Arr_T( Map_Idx_T'First .. Map_Idx_T(FS.Num_Lines),
                         Map_Idx_T'First .. Map_Idx_T(FS.Line_Length));
         Row_Idx : Map_Idx_T := Map_Idx_T'First;
      begin
         Open( File, In_File, Input_File );

         while not End_Of_File( File ) loop
            declare
               Line: constant String := Get_Line( File );
            begin
               for I in Line'First .. Line'Last loop
                  Map( Row_Idx, Map_Idx_T(I) ) := Line( I );
               end loop;
            end;
            Row_Idx := Row_Idx + 1;
         end loop;

         Close(File);

         return Map;
      end Get_Map;
      
      function Get_Coord_Location( Coord: Character; Map: Map_Arr_T ) return Map_Coord_R is
      begin
         for I in Map'Range( 1 ) loop
            for J in Map'Range( 2 ) loop
               if Map( I, J ) = Coord then
                  return (Row => Map_Idx_T(I), Col => Map_Idx_T(J));
               end if;
            end loop;
         end loop;
         return ( Row => Map_Idx_T'First, Col => Map_Idx_T'First);
      end Get_Coord_Location;

      Map: Map_Arr_T := Get_Map( Input_File );
      Start_Coord : constant Map_Coord_R := Get_Coord_Location( 'S', Map );
      End_Coord : constant Map_Coord_R := Get_Coord_Location( 'E', Map );
      Steps: Natural;
      Hiking_Steps: Natural := Natural'Last;
   begin
      Put_Line( "--- Day 12 ---" );
      Put_Line( "Part 1" );
      
      -- Jank remappiung
      for I in Map'Range(1) loop
         for J in Map'Range(2) loop
            if Map( I, J ) = 'S' then
               Map( I, J ) := 'a';
            end if;
            if Map( I, J ) = 'E' then
               Map( I, J ) := 'z';
            end if;
         end loop;
      end loop;

      Steps := Minimum_Step_Path( Start_Loc => Start_Coord, End_Loc => End_Coord, Map => Map );
      Put_Line( "Minimum steps to end: " & Steps'Image );
      
      -- Jank brute force search for path from a
      for I in Map'Range(1) loop
         for J in Map'Range(2) loop
            if Map( I, J ) = 'a' then
               Steps := Minimum_Step_Path( Start_Loc => (Row => I, Col => J), End_Loc => End_Coord, Map => Map );
               if Steps < Hiking_Steps then
                  Hiking_Steps := Steps;
               end if;
            end if;
         end loop;
      end loop;
      
      Put_Line( "Minimum hiking path steps: " & Hiking_Steps'Image );
   end Run_Day_12;

   procedure Run_Day_13( Input_File: String ) is
      use Ada.Containers;
      use Days.Day_13;
      use Signal_Vec_P;
      use Signals_P;
      use All_Signals_P;
      use Ada.Strings.Bounded;

      function Get_Signal_List( Input_File: String ) return All_Signals_P.Vector is
         function Process_Signals_Line( Line: String ) return Signal_Vec_P.Vector is

            package Num_Store_P is new Generic_Bounded_Length( 100 );
            use Num_Store_P;

            Num_Store : Num_Store_P.Bounded_String := To_Bounded_String("");
            Signals : Signal_Vec_P.Vector( Count_Type(Signal_Idx_T'Last) );
            Signal : Signals_P.Vector( Count_Type(Signal_Idx_T'Last) );
            Prev_Char : Character := ' ';
            Depth_Count: Natural := 0;
         begin
            for Str_Idx in Line'Range loop
               if Line( Str_Idx ) = '[' then
                  -- If we have entries in the signals, we add them at the current depth
                  if not Is_Empty( Signal ) then
                     Append( Signals, (Signals => Signal, Depth => Depth_Count) );
                  end if;
                  -- Every time we see a new entry clear the vector and increment depth
                  -- If we hit multiple [, it will just work through them increasing the depth
                  Clear(Signal);
                  Depth_Count := Depth_Count + 1;

               elsif Line( Str_Idx ) = ']' then
                  if Num_Store /= "" then
                     Append( Signal, Signal_Val_T'Value( To_String( Num_Store ) ));
                     Num_Store := To_Bounded_String("");
                  end if;
                  -- If we arent going up a cascading chain of ], then add signal to vector
                  if Prev_Char /= ']' then
                     Append( Signals, (Signals => Signal, Depth => Depth_Count) );
                  end if;
                  Clear(Signal);
                  Depth_Count := Depth_Count - 1;

               elsif Line( Str_Idx ) = ',' then 
                  -- If we see a comma and we have a number, add signal to the store and reset it
                  -- Else just skip it as it is between list entries
                  if Num_Store /= "" then
                     Append( Signal, Signal_Val_T'Value( To_String( Num_Store ) ));
                     Num_Store := To_Bounded_String("");
                  end if;
               elsif Line( Str_Idx ) in '1' .. '9' then
                  -- Every time we see a number, add it to the number store string
                  Num_Store := Num_Store & Line( Str_Idx );
               end if;

               Prev_Char := Line( Str_Idx );
            end loop;

            return Signals;
         end Process_Signals_Line;
         
         File: File_Type;
         Signals : All_Signals_P.Vector(Count_Type(All_Signals_Idx_T'Last));
      begin
         Open( File, In_File, Input_File );
         
         while not End_Of_File( File ) loop
            declare
               Left: constant String := Get_Line( File );
               Right: constant String := Get_Line( FIle );
            begin
               Append( Signals, (Left => Process_Signals_Line( Left ), 
                                 Right => Process_Signals_Line( Right ) ) );
            end;
            
            -- Given there is a space seperating it, skip it if not the end of file
            if not End_Of_File( File ) then
               Skip_Line( FIle );
            end if;
         end loop;

         Close(File);
         return Signals;
      end Get_Signal_List;
      
      Signals : constant All_Signals_P.Vector := Get_Signal_List( Input_File );
      Correct_Signals : constant Natural := Count_Correct_Signals( Signals );
   begin
      Put_Line( "--- Day 13 ---" );
      Put_Line( "Part 1" );
      Put_Line( "Count of correct signals: " & Correct_Signals'Image );
   end Run_Day_13;
   
   procedure Run_Day_14( Input_File: String ) is
      use Day_14;
      use Utilities;
      
      function Build_Sand_Grid( Input_File: String ) return Sand_Arr_T is
         use Ada.Containers;
         use Split_Str_P;
         use Ada.Strings.Maps;
         use Ada.Strings.Maps.Constants;

         type Stone_R is record
            Row : Sand_Row_Idx;
            Col : Sand_Col_Idx;
         end record;
         
         package Stone_Line_P is new Formal_Vectors( Index_Type => Positive,
                                                     Element_Type => Stone_R );
         use Stone_Line_P;

         Sand_Arr : Sand_Arr_T := ( others => ( others => Air ) );
         File : File_Type;
      begin
         -- Get the line from the string. Split based on ->. Then we want to trim each one and split based on ,.
         -- We can then append each entry to the array.
         -- Once we have built the array, go through and put all the stone entries in.
         Open( File, In_File, Input_File );
         
         while not End_Of_Line( File ) loop
            declare
               Line: constant String := Get_Line( File );
               Stone_Lines : constant Split_Str_Arr := Split_String( Line, "->" );
               Entries : Stone_Line_P.Vector( 100 );
            begin
               for Stone_Str of Stone_Lines loop
                  declare

                     Stone_Arr : constant Split_Str_Arr := Split_String( To_String(Stone_Str), "," );
                     -- Remove anything that isnt a digit and convert them to row/col/
                     Row: constant Sand_Row_Idx := Sand_Row_Idx'Value( To_String( Trim( Source => Stone_Arr(1), 
                                                                                        Left => not Decimal_Digit_Set, 
                                                                                        Right => not Decimal_Digit_Set ) ) );
                     
                     Col: constant Sand_Col_Idx := Sand_Col_Idx'Value( To_String( Trim( Source => Stone_Arr(0), 
                                                                                        Left => not Decimal_Digit_Set, 
                                                                                        Right => not Decimal_Digit_Set ) ) );
                  begin
                     Append( Entries, ( Row => Row, Col => Col ) );
                  end;
               end loop;
               
               for I in First_Index( Entries ) + 1 .. Last_Index( Entries ) loop
                  -- Look back to see where we go from to end
                  declare
                     Prev_Entry : constant Stone_R := Element( Entries, I - 1 );
                     Curr_Entry : constant Stone_R := Element( Entries, I );
                  begin
                     -- As the index can only be positive, go from the min to the max for row/col.
                     for R in Sand_Row_Idx'Min( Prev_Entry.Row, Curr_Entry.Row ) .. Sand_Row_Idx'Max( Prev_Entry.Row, Curr_Entry.Row ) loop
                        for C in Sand_Col_Idx'Min( Prev_Entry.Col, Curr_Entry.Col ) .. Sand_Col_Idx'Max( Prev_Entry.Col, Curr_Entry.Col ) loop
                           Sand_Arr( R, C ) := Rock;
                        end loop;
                     end loop;
                  end;
               end loop;
            end;
         End loop;
         Close( File );
         return Sand_Arr;
      end Build_Sand_Grid;

      procedure Print_Sand( Grid: Sand_Arr_T ) is
         Row_Str: String( Grid'First( 2 ) .. Grid'Last( 2 ) );
      begin
         for Row in Grid'Range( 1 ) loop
            for Col in Grid'Range( 2 ) loop
               Row_Str( Col ) := Sand_Lookup( Grid( Row, Col ) );
            end loop;

            Put_Line( Row_Str );
         end loop;
      end Print_Sand;
      
      function Add_Floor_To_Grid( Grid: Sand_Arr_T ) return Sand_Arr_T is
         GF : Sand_Arr_T := Grid;
         Last_Stone : Sand_Row_Idx;
         Found_Last_Stone: Boolean := False;
      begin
         for Row in reverse GF'Range( 1 ) loop
            for Col in GF'Range( 2 ) loop
               if GF( Row, Col ) = Rock then
                  Last_Stone := Row + 2;
                  Found_Last_Stone := True;
                  exit;
               end if;
            end loop;
            
            if Found_Last_Stone then
               exit;
            end if;
         end loop;
         
         for Col in GF'Range( 2 ) loop
            GF( Last_Stone, Col ) := Rock;
         end loop;
         return GF;
      end Add_Floor_To_Grid;

      Grid : Sand_Arr_T := Build_Sand_Grid( Input_File );
      Grid_With_Floor : Sand_Arr_T := Add_Floor_To_Grid( Grid );
      Sand_Count : Natural;
   begin
      Put_Line( "--- Day 14 ---" );
      Count_Units_Coming_To_Rest( Grid, Sand_Count );
      --Print_Sand( Grid_With_Floor );
      Put_Line( "Part 1" );
      Put_Line( "Amount of Sand that fell to void: " & Sand_Count'Image );
      
      Count_Units_Coming_To_Rest( Grid_With_Floor, Sand_Count );
      Put_Line( "Part 2" );
      Put_Line( "Amount of Sand that fell to floor: " & Sand_Count'Image );
   end Run_Day_14;

end Days;
