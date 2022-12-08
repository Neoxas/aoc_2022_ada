with Ada.Strings.Bounded;
package Days.Day_6 with SPARK_Mode is

   MAX_SEARCH_STRING : constant := 5000;
   package Search_Str_P is new Ada.Strings.Bounded.Generic_Bounded_Length( MAX_SEARCH_STRING );
   use Search_Str_P;
   
   subtype Window_Size_T is Integer range 1 .. MAX_SEARCH_STRING;

   function Find_First_Non_Overlap( String: Search_Str_P.Bounded_String; Size: Window_Size_T ) return Window_Size_T;

end Days.Day_6;
