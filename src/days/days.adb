with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;
with Days.Day_1; use Days.Day_1;
with Days.Day_2; use Days.Day_2;
with Days.Day_3; use Days.Day_3;

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
      function Get_Backpacks( Input_File: String ) return Backpacks_P.Vector is
         File : File_Type;
         Backpacks : Backpacks_P.Vector( MAX_BACKPACK_SIZE );
         str : Backpack_Str_T := (others => ' ' );
      begin
         Open( File, In_File, Input_File );
         
         while not End_Of_File( File ) loop
            declare
               Line : String := Get_Line( File );
            begin
               str( str'First .. Line'Length ) := Line;
               str( str'First + Line'Length .. str'Last ) := ( others => ' ' );
               Append( Backpacks, str );
            end ;
         end loop;
         
         Close( File );
         Append( Backpacks, str );
         return Backpacks;
      end Get_Backpacks;
      
      Backpacks : constant Backpacks_P.Vector := Get_Backpacks( Input_File );
   begin
      Put_Line( "Hello, Day 3" );
      Put_Line( String( Element( Backpacks, First_Index( Backpacks ) ) ) );
   end Run_Day_3;

end Days;
