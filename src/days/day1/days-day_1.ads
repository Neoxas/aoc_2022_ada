package Days.Day_1 with SPARK_Mode is
    type Calories_Arr_T is array( Positive range<>) of Positive with
      Predicate => ( Calories_Arr_T'First = Positive'First );

    function Get_Max_Elf_Calories ( Calories_Arr: Calories_Arr_T ) return Natural with
      Pre => (Calories_Arr'Last > Calories_Arr'First);

    function Get_Total_Calories_Of_Top_X_Elves ( Calories_Arr: Calories_Arr_T; Elves_To_Count: Positive ) return Natural with
      Pre => (Calories_Arr'Length >= Elves_To_Count);

private

    function Get_Max_Idx( Arr: Calories_Arr_T ) return Positive with
      Pre => (Arr'Length > 0),
      Post => (Get_Max_Idx'Result in Arr'Range and
                 ( for all X_Idx in Arr'Range => Arr(Get_Max_Idx'Result) >= Arr(X_Idx))),
      Global => null;

end Days.Day_1;
