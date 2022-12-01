package Days.Day_1 with SPARK_Mode is
    type Calories_Arr_T is array( Natural range<>) of Natural;

    function Get_Max_Elf_Calories ( Calories_Arr: Calories_Arr_T ) return Natural;

    function Get_Total_Calories_Of_Top_X_Elves ( Calories_Arr: Calories_Arr_T; Elves_To_Count: Natural ) return Natural;

private

    function Get_Max_Idx( Arr: Calories_Arr_T ) return Natural;

end Days.Day_1;
