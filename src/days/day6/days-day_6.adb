package body Days.Day_6 is
   
   function All_Entries_In_Slice_Unique( Slice : Search_Str_P.Bounded_String ) return Boolean is 
      ( for all I in 1 .. Length(Slice) => 
            (for all J in 1 ..Length(Slice) => 
               (if I /= J then Element( Slice, I ) /= Element(Slice,J) else True)  ));

   function Find_First_Non_Overlap( String: Search_Str_P.Bounded_String; Size: Window_Size_T ) return Window_Size_T is
      First_Idx : Window_Size_T := Window_Size_T'First;
      Slice : Search_Str_P.Bounded_String;
   begin
      for Idx in 1 .. Window_Size_T(Length(String)) - Size loop
         Slice := Bounded_Slice(String, Idx, Idx + Size );
         if All_Entries_In_Slice_Unique( Slice ) then
            -- There appears to be an out by one error here for some reason. 
            -- This is only for message, not packet marker.
            First_Idx := Idx + Size - 1;
            exit;
         end if;
      end loop;
      return First_Idx;
   end Find_First_Non_Overlap;

end Days.Day_6;
