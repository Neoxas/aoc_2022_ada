package body Days.Day_2 with SPARK_Mode is
    subtype Rps_Score_T is Score_Base_T  range 1 ..3;
    subtype Outcome_Score_T is Score_Base_T  range 0 .. 6;
    
    type Elf_RPS_Lookup_T is array( ElfCode'Range ) of RPS;
    Elf_RPS_Lookup : constant Elf_RPS_Lookup_T := ( 'A' => ROCK, 'B' => PAPER, 'C' => SCISSORS );
    
    
    
    function Convert_To_Matched_Round( Round_String: Round_Str_T ) return Round_T is 
        type You_RPS_Lookup_T is array( YouCode'Range ) of RPS;
        You_RPS_Lookup : constant You_RPS_Lookup_T := ( 'X' => ROCK, 'Y' => PAPER, 'Z' => SCISSORS );
    begin
        return ( 
                 Elf => Elf_RPS_Lookup(
                   ElfCode'Value(Round_String(Round_String'First)'Image)), 
                 You => You_RPS_Lookup(
                   YouCode'Value(Round_String(Round_String'Last)'Image)));
    end Convert_To_Matched_Round;
    
    function Convert_To_Predicted_Round( Round_String: Round_Str_T ) return Round_T is
        type You_Outcome_Lookup_T is array( YouCode'Range ) of Outcome;
        You_Outcome_Lookup : constant You_Outcome_Lookup_T := ( 'X' => LOSE, 'Y' => DRAW, 'Z' => WIN );
        
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

        Elf : constant RPS := Elf_RPS_Lookup(ElfCode'Value(Round_String(Round_String'First)'Image));
        You : constant RPS := Get_Result_Pair( Required_Outcome => You_Outcome_Lookup( YouCode'Value( Round_String(Round_String'Last)'Image)),
                                               Elf_RPS => Elf);
    begin
        return ( Elf => Elf, You => You );
    end Convert_To_Predicted_Round;
    
    function Get_Round_Score( Round: Round_T ) return Score_Base_T is
        type Outcome_Score_Lookup_T is array( Outcome'Range ) of Outcome_Score_T;
        Outcome_Score_Lookup : constant Outcome_Score_Lookup_T := ( WIN => 6, DRAW => 3, LOSE => 0 );
        
        type RPS_Score_Lookup_T is array( RPS'Range ) of RPS_Score_T;
        RPS_Score_Lookup : constant RPS_Score_Lookup_T := ( ROCK => 1, PAPER => 2, SCISSORS => 3 );
        
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
    begin
        return Outcome_Score_Lookup( Get_Round_Result( Round ) ) + RPS_Score_Lookup(Round.You);
    end Get_Round_Score;
    
    function Get_Guide_Score( Rounds: Rounds_T; End_Round: Round_Count_T ) return Rounds_Result_T is
        Result: Rounds_Result_T := Rounds_Result_T'First;
    begin 
        for Round_Idx in Rounds'First .. End_Round loop
            pragma Loop_Invariant(Rounds_Result_T'Last - Score_Base_T'Last > Result );
            Result := Result + Get_Round_Score( Rounds(Round_Idx) );
        end loop;
        return Result;
    end Get_Guide_Score;
      

end Days.Day_2;
