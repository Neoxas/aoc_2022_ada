package Days.Day_2 with SPARK_Mode Is
    pragma Elaborate_Body;
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
      Pre => ( Rounds'Length > 0 );

private
    function Get_Round_Score( Round: Round_T ) return Natural;
end Days.Day_2;
