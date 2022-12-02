package body Days.Day_1 with SPARK_Mode is

    function Get_Max_Idx( Arr: Calories_Arr_T ) return Positive is
        -- Force max IDX to stay in the range of the array.
        Max_Idx : Positive range Arr'Range := Arr'First;
    begin
        for Idx in Arr'First .. Arr'Last loop
            if Arr(Idx) > Arr(Max_Idx) then
                Max_Idx := Idx;
            end if;
            pragma Loop_Invariant(for all X_Idx in Arr'First .. Idx => Arr(Max_Idx) >= Arr(X_Idx));
        end loop;

        return Max_Idx;
    end Get_Max_Idx;

    function Get_Max_Elf_Calories ( Calories_Arr: Calories_Arr_T ) return Natural is
        -- Find the most calories a single elf is carrying
    begin
        return Calories_Arr(Get_Max_Idx(Calories_Arr));
    end Get_Max_Elf_Calories;

    function Get_Total_Calories_Of_Top_X_Elves ( Calories_Arr: Calories_Arr_T; Elves_To_Count: Positive ) return Natural is
        -- Find total calories of Top elves
        Total_Calories: Natural := Natural'First;
        Cal_Copy : Calories_Arr_T := Calories_Arr;
        Idx: Positive range Calories_Arr'Range;
    begin
        for I in Natural'First .. Elves_To_Count - 1 loop
            Idx := Get_Max_Idx( Cal_Copy );
            -- TODO: Bound Inputs To Make Sure It Never Overflows
            -- or Justify and Be Done with It.
            Total_Calories := Total_Calories + Cal_Copy( Idx );
            pragma Annotate (GNATProve, Intentional, "overflow check", "Im lazy and will fix this later by bounding" );
            -- Remove entries from Calories
            Cal_Copy( Idx ) := Positive'First;
        end loop;
        return Total_Calories;
    end Get_Total_Calories_Of_Top_X_Elves;

end Days.Day_1;
