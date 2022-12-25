package body Days.Day_14 with SPARK_Mode is
   type Sand_R is record
      Row : Sand_Row_Idx;
      Col : Sand_Col_Idx;
   end record;
   
   procedure Drop_Sand( Grid: in out Sand_Arr_T; Count: in out Natural;  End_Of_Drop: in out Boolean ) is
      -- Start the sand drop
      Sand_Point: Sand_R := ( Row => 0, Col => 500 );
      Below_Sand : Sand_Symbols_E;
      Sand_At_Rest: Boolean := False;
   begin
      while not Sand_At_Rest loop
         if Sand_Point.Row = Sand_Row_Idx'Last then
            End_Of_Drop := True;
            exit;
         else
            Below_Sand := Grid( Sand_Point.Row + 1, Sand_Point.Col );
            case Below_Sand is
               when Air =>
                  Sand_Point.Row := Sand_Point.Row + 1;
               when Rock | Sand =>
                  declare
                     Below_Left : constant Sand_Symbols_E := Grid( Sand_Point.Row + 1, Sand_Point.Col - 1);
                     Below_Right : constant Sand_Symbols_E := Grid( Sand_Point.Row + 1, Sand_Point.Col + 1);
                  begin
                     if (Below_Left in Sand | Rock) and (Below_Right in Sand | Rock ) then
                        Grid( Sand_Point.Row, Sand_Point.Col ) := Sand;
                        Sand_At_Rest := True;
                     elsif Below_Left = Air then
                        Sand_Point.Col := Sand_Point.Col - 1;
                        Sand_Point.Row := Sand_Point.Row + 1;
                     elsif Below_Right = Air then
                        Sand_Point.Col := Sand_Point.Col + 1;
                        Sand_Point.Row := Sand_Point.Row + 1;
                     end if;
                  end;
            end case;
         end if;
      end loop;
      
      -- If the sand has come to a stop, add to the count
      if Sand_At_Rest then
         Count := Count + 1;
      end if;
      
      -- If we have drop a piece of sand at the entry, then stop
      if Sand_Point.Col = 500 and Sand_Point.Row = 0 then
         End_Of_Drop := True;
      end if;
   end Drop_Sand;

   procedure Count_Units_Coming_To_Rest( Grid: in out Sand_Arr_T; Count: out Natural ) is
      Sand_Hit_Air: Boolean := False;
   begin
      Count := 0;
      while not Sand_Hit_Air loop
         Drop_Sand( Grid, Count, Sand_Hit_Air );
      end loop;
   end Count_Units_Coming_To_Rest;

end Days.Day_14;
