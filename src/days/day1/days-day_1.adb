with Ada.Text_IO; use Ada.Text_IO;

package body Days.Day_1 with SPARK_Mode => Off is

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


    function Get_Max_Elf_Calories ( Calories_Vec: Nat_Vec.Vector ) return Natural is
        -- Run Part 1 to find the elf who is carrying the most calories
    begin
        return Calories_Vec(Get_Max_Idx(Calories_Vec));
    end Get_Max_Elf_Calories;

    function Get_Total_Calories_Of_Top_X_Elves ( Calories_Vec: Nat_Vec.Vector; Elves_To_Count: Natural ) return Natural is
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
        return Total_Calories;
    end Get_Total_Calories_Of_Top_X_Elves;

end Days.Day_1;
