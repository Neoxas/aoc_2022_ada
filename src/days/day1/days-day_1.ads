package Days.Day_1 with SPARK_Mode is
    type Calories_Arr_T is array( Natural range<>) of Natural with
      Predicate => ( Calories_Arr_T'First = Natural'First );

    function Get_Max_Elf_Calories ( Calories_Arr: Calories_Arr_T ) return Natural with
      Pre => (Calories_Arr'Last > 0 and Calories_Arr'Last > Calories_Arr'First);

    function Get_Total_Calories_Of_Top_X_Elves ( Calories_Arr: Calories_Arr_T; Elves_To_Count: Natural ) return Natural with
      Pre => (Calories_Arr'Last > 0 and Calories_Arr'Last - Calories_Arr'First >= Elves_To_Count);

private

    function Get_Max_Idx( Arr: Calories_Arr_T ) return Natural with
      Pre => (Arr'Last > 0 and Arr'First < Arr'Last),
      Post => (Get_Max_Idx'Result <= Arr'Last and Get_Max_Idx'Result >= Arr'First);

end Days.Day_1;
