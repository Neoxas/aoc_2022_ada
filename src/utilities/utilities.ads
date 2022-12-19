with Ada.Strings.Bounded; use Ada.Strings.Bounded;
package Utilities is

   function Get_Filename return String;
   function Get_Day return String;

   package Split_Str_P is new Generic_Bounded_Length( 100 );
   type Split_Str_Arr is array( Natural range<>) of Split_Str_P.Bounded_String;

   function Split_String( Str: String; Pattern: String ) return Split_Str_Arr;

   type File_Structure_R is record
      Line_Length : Positive;
      Num_Lines : Positive;
   end record;
   function Get_File_Structure( Input_File: String ) return File_Structure_R;

end Utilities;
