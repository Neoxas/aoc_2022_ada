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
                if Line /= "" then -- Entries are split by a blank line
                    Curr_Elf := Curr_Elf + Integer'Value( Line );
                else
                    Max := Integer'Max( Max, Curr_Elf );
                    Curr_Elf := 0;
                end if;
            end;
        end loop;
        -- Final Max calculation (to account for EOF)
        Max := Integer'Max( Max, Curr_Elf );

        Close( File );
        Put_Line (Item => "Max elf calories: " & Max'Image);
    end Run_Day_1_Part_1;

    procedure Run_Day_1_Part_2 ( Input_File: String ) is
        type Max_Arr_T is array( 1 .. 3 ) of Integer;
        -- Define shuffling procedure to keep track of max 3 values
        procedure Shuffle_Max( Max_Calories: in out Max_Arr_T; Curr_Elf: in out Integer ) is
        begin
            if Curr_Elf >= Max_Calories(1) then
                Max_Calories( 2 .. 3 ) := Max_Calories( 1 .. 2 );
                Max_Calories( 1 ) := Curr_Elf;
            elsif Curr_Elf >= Max_Calories(2) then
                Max_Calories( 3 ) := Max_Calories( 2 );
                Max_Calories( 2 ) := Curr_Elf;
            elsif Curr_Elf >= Max_Calories(3) then
                Max_Calories( 3 ) := Curr_Elf;
            end if;
            Curr_Elf := 0;
        end Shuffle_Max;

        File : File_Type;

        Max_Calories : Max_Arr_T := ( others => 0 );
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
                    Shuffle_Max( Max_Calories, Curr_Elf);
                end if;
            end;
        end loop;
        Shuffle_Max( Max_Calories, Curr_Elf);

        Close( File );
        Put_Line (Item => "Max elf calories: " & Integer'Image(Max_Calories(1) + Max_Calories(2) + Max_Calories(3)));
    end Run_Day_1_Part_2;

    procedure Run_Day_1 ( Input_File: String ) is
    begin
        Put_Line( "--- Day 1 ---" );
        Put_Line( "Part 1" );
        Run_Day_1_Part_1( Input_File );
        Put_Line( "Part 2" );
        Run_Day_1_Part_2( Input_File );
    end Run_Day_1;

end Days.Day_1;
