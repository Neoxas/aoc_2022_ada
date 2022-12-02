package Days.Day_2 with SPARK_Mode is
    type Round_Count_T is range 1 .. 10_000;

    type RPS is ( ROCK, PAPER, SCISSORS );
    type Outcome is ( LOSE, DRAW, WIN );

    type Round_T is record
        Elf : RPS;
        You : RPS;
    end record;

    subtype Round_Str_T is String( 1 .. 3 );
    type Rounds_T is array( Round_Count_T ) of Round_T;

    function Convert_To_Matched_Round( Round_String: Round_Str_T ) return Round_T with
      Pre => ( Round_String( Round_String'First ) in 'A'| 'B' | 'C'
               and Round_String( Round_String'Last ) in 'X' | 'Y' | 'Z' ) ;

    function Convert_To_Predicted_Round( Round_String: Round_Str_T ) return Round_T with
      Pre => ( Round_String( Round_String'First ) in 'A'| 'B' | 'C'
               and Round_String( Round_String'Last ) in 'X' | 'Y' | 'Z' ) ;

    function Get_Guide_Score( Rounds: Rounds_T; End_Round: Round_Count_T ) return Natural with
      Pre => ( Rounds'Length > 0 and End_Round in Rounds'Range and End_Round > Rounds'First);

private
    subtype Score_Base_T is Natural range 0 .. 9;
    function Get_Round_Score( Round: Round_T ) return Score_Base_T with
      Post => (Natural'Last - Score_Base_T'Last - 1 > Get_Round_Score'Result );
end Days.Day_2;
