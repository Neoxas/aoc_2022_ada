with Ada.Text_IO; use Ada.Text_IO;

package body Days.Day_1 with SPARK_Mode => Off is

    procedure Run_Day_1_Part_1 ( Input_File: String ) is
        File : File_Type;
        Max : Integer := 0;
        Curr_Elf : Integer := 0;
    begin
        Open(File => File, Mode => In_File, Name => Input_File);

        while (not End_Of_File(File) ) loop
            declare
                Line : constant String := Get_Line(File => File);
            begin
                if Line /= "" then
                    Curr_Elf := Curr_Elf + Integer'Value( Line );
                else
                    Max := Integer'Max( Max, Curr_Elf );
                    Curr_Elf := 0;
                end if;
            end;
        end loop;

        Close( File );
        Put_Line (Item => "Max elf calories: " & Max'Image);
    end Run_Day_1_Part_1;

    procedure Run_Day_1 ( Input_File: String ) is
    begin
        Put_Line( "--- Day 1 ---" );
        Put_Line( "Part 1" );
        Run_Day_1_Part_1( Input_File );
    end Run_Day_1;

end Days.Day_1;
