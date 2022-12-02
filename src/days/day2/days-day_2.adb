package body Days.Day_2 with SPARK_Mode is
    function Convert_To_Elf( Hint : Character ) return RPS is 
          ( if Hint = 'A' then ROCK elsif Hint = 'B' then PAPER else SCISSORS ) with
      Pre => ( Hint in 'A'|'B'|'C');
    
    function Convert_To_Matched_Round( Round_String: Round_Str_T ) return Round_T is        
        function Convert_To_You( Hint : Character ) return RPS is 
          ( if Hint = 'X' then ROCK elsif Hint = 'Y' then PAPER else SCISSORS ) with 
          Pre => ( Hint in 'X'|'Y'|'Z');
    begin
        return ( 
                 Elf => Convert_To_Elf(Round_String(Round_String'First)), 
                 You => Convert_To_You(Round_String(Round_String'Last)));
    end Convert_To_Matched_Round;
    
    function Convert_To_Predicted_Round( Round_String: Round_Str_T ) return Round_T is
        function Get_Required_Result( Hint : Character ) return Outcome is 
            ( if Hint = 'X' then LOSE elsif Hint = 'Y' then DRAW else WIN ) with 
          Pre => ( Hint in 'X'|'Y'|'Z');
        
        function Get_Result_Pair( Required_Outcome: Outcome; Elf_RPS: RPS ) return RPS is
            type Res_Lookup_Arr_T is array( RPS'Range ) of RPS;
            -- If they play input, I need to play output to loose.
            Losing_Paring : constant Res_Lookup_Arr_T := ( ROCK => SCISSORS, PAPER => ROCK, SCISSORS => PAPER );
            -- If they play input, I need to play output to win.
            Winning_Paring : constant Res_Lookup_Arr_T := ( ROCK => PAPER, PAPER => SCISSORS, SCISSORS => ROCK );

        begin
            case Required_Outcome is
                when DRAW => return Elf_RPS;
                when LOSE => return Losing_Paring( Elf_RPS );
                when WIN => return Winning_Paring( Elf_RPS );
            end case;
        end Get_Result_Pair;

        Elf : constant RPS := Convert_To_Elf(Round_String(Round_String'First));
        You : constant RPS := Get_Result_Pair( Required_Outcome => Get_Required_Result( Round_String(Round_String'Last)),
                                     Elf_RPS => Elf);
    begin
        return ( Elf => Elf, You => You );
    end Convert_To_Predicted_Round;
    
    function Get_Round_Score( Round: Round_T ) return Natural is
        function Get_Round_Result( Round : Round_T ) return Outcome is
        begin
            if Round.You = Round.Elf then
                return DRAW;
            elsif ( Round.You = ROCK and Round.Elf = SCISSORS ) or
              ( Round.You = PAPER and Round.Elf = ROCK ) or
              ( Round.You = SCISSORS and Round.Elf = PAPER )
            then
                return WIN;
            else
                return LOSE;
            end if;
        end Get_Round_Result;
        
        function Get_RPS_Score( Choice: RPS ) return Natural is ( if Choice = ROCK then 1 elsif Choice = PAPER then 2 else 3 );
        function Get_Outcome_Score( Result : Outcome ) return Natural is ( if Result = WIN then 6 elsif Result = DRAW then 3 else 0 );
        
    begin
        return Get_Outcome_Score( Get_Round_Result( Round ) ) + Get_RPS_Score(Round.You);
    end Get_Round_Score;
    
    function Get_Guide_Score( Rounds: Rounds_T; End_Round: Round_Count_T ) return Natural is
        Result: Natural := Natural'First;
    begin 
        for Round_Idx in Rounds'First .. End_Round loop
            Result := Result + Get_Round_Score( Rounds(Round_Idx) );
        end loop;
        return Result;
    end Get_Guide_Score;
      

end Days.Day_2;
