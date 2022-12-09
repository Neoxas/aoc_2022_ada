with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;
with Days.Day_1; use Days.Day_1;
with Days.Day_2; use Days.Day_2;
with Days.Day_3; use Days.Day_3;
with Days.Day_4; use Days.Day_4;
with Days.Day_5; use Days.Day_5;
with Days.Day_6; use Days.Day_6;
with Days.Day_8; use Days.Day_8;

package body Days is
    
    package Nat_Vec is new
      Ada.Containers.Vectors( Index_Type => Natural, Element_Type => Natural );

    procedure Run_Day_1( Input_File: String ) is
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
   begin
      Put_Line( "--- Day 6 ---" );
      Put_Line( "Part 1" );
      Put_Line( Input_File );
   end Run_Day_8;

end Days;
