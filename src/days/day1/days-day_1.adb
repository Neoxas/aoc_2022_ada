package body Days.Day_1 with SPARK_Mode => On is

    function Get_Max_Idx( Arr: Calories_Arr_T ) return Natural is
        -- Get index of maximum value from vector
        Tmp : Natural := Natural'First;
        Max_Idx : Natural := Arr'First;
    begin
        for Idx in Arr'First .. Arr'Last loop
            if Arr(Idx) > Tmp then
                Max_Idx := Idx;
                Tmp := Arr(Idx);
            end if;
        end loop;

        return Max_Idx;
    end Get_Max_Idx;

    function Get_Max_Elf_Calories ( Calories_Arr: Calories_Arr_T ) return Natural is
        -- Find the most calories a single elf is carrying
    begin
        return Calories_Arr(Get_Max_Idx(Calories_Arr));
    end Get_Max_Elf_Calories;

    function Get_Total_Calories_Of_Top_X_Elves ( Calories_Arr: Calories_Arr_T; Elves_To_Count: Natural ) return Natural is
        -- Find total calories of Top elves
        Total_Calories: Natural := Natural'First;
        Cal_Copy : Calories_Arr_T := Calories_Arr;
        Idx: Natural;
    begin
        for I in Natural'First .. Elves_To_Count - 1 loop
            Idx := Get_Max_Idx( Cal_Copy );
            Total_Calories := Total_Calories + Cal_Copy( Idx );
            -- Remove entries from Calories
            Cal_Copy( Idx ) := Natural'First;
        end loop;
        return Total_Calories;
    end Get_Total_Calories_Of_Top_X_Elves;

end Days.Day_1;
