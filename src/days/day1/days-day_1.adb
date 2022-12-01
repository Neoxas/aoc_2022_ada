with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;

package body Days.Day_1 with SPARK_Mode => Off is
    package Nat_Vec is new
      Ada.Containers.Vectors( Index_Type => Natural, Element_Type => Natural );

    function Get_Calories_From_File( Input_File: String ) return Nat_Vec.Vector is
        -- Gets a Vector containing each elf with the relevant calories
        -- Each Elf in the input file is seperated by a blank line
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

        return Vec;
    end Get_Calories_From_File;

    function Get_Max_Idx( Vec: Nat_Vec.Vector ) return Natural is
        -- Get index of maximum value from vector
        Tmp : Natural := Natural'First;
        Max_Idx : Natural := 0;
    begin
        for Idx in Vec.First_Index .. Vec.Last_Index loop
            if Vec(Idx) > Tmp then
                Max_Idx := Idx;
                Tmp := Vec(Idx);
            end if;
        end loop;

        return Max_Idx;
    end Get_Max_Idx;


    procedure Run_Day_1_Part_1 ( Calories_Vec: Nat_Vec.Vector ) is
        -- Run Part 1 to find the elf who is carrying the most calories
    begin
        Put_Line (Item => "Max elf calories: " & Natural'Image(
                  Calories_Vec(Get_Max_Idx(Calories_Vec)
                   )));
    end Run_Day_1_Part_1;

    procedure Run_Day_1_Part_2 ( Calories_Vec: Nat_Vec.Vector; Elves_To_Count: Natural ) is
        -- Run Part 2 to find the sum of calories for the top X elves
        Total_Calories: Natural := Natural'First;
        Cal_Copy : Nat_Vec.Vector := Calories_Vec;
        Idx: Natural;
    begin
        for I in Natural'First .. Elves_To_Count - 1 loop
            Idx := Get_Max_Idx( Cal_Copy );
            Total_Calories := Total_Calories + Cal_Copy( Idx );
            -- Remove entries from Calories
            Cal_Copy.Delete( Idx );
        end loop;
        Put_Line (Item => "Max elf calories: " & Total_Calories'Image);
    end Run_Day_1_Part_2;

    procedure Run_Day_1 ( Input_File: String ) is
        -- Get results for AOC Day 1 printed to the command line
        Cal_Vec : constant Nat_Vec.Vector := Get_Calories_From_File( Input_File );
    begin
        Put_Line( "--- Day 1 ---" );
        Put_Line( "Part 1" );
        Run_Day_1_Part_1( Cal_Vec );
        Put_Line( "Part 2" );
        Run_Day_1_Part_2( Cal_Vec, 3 );
    end Run_Day_1;

end Days.Day_1;
