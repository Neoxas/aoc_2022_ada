package Days.Day_1 with SPARK_Mode is

    function Get_Max_Elf_Calories ( Calories_Vec: Nat_Vec.Vector ) return Natural;

    function Get_Total_Calories_Of_Top_X_Elves ( Calories_Vec: Nat_Vec.Vector; Elves_To_Count: Natural ) return Natural;

private

    function Get_Max_Idx( Vec: Nat_Vec.Vector ) return Natural;

end Days.Day_1;
