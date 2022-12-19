with Ada.Command_Line;
with Ada.Strings.Search;
with Ada.Text_IO; use Ada.Text_IO;
package body Utilities is
   use Ada.Strings.Search;

    function Get_Filename return String is
        -- Get the filename from the command line flag --file
        package CLI renames Ada.Command_Line;
    begin
        for i in 1 .. CLI.Argument_Count loop
            if( CLI.Argument(i) = "--file") then
                return CLI.Argument(i+1);        
            end if;
        end loop;
        return "";
    end;

    function Get_Day return String is
        -- Get the day for the command line flag --day
    begin
        for i in 1 .. Ada.Command_Line.Argument_Count loop
            if( Ada.Command_Line.Argument(i) = "--day") then
                return Ada.Command_Line.Argument(i+1);
            end if;
        end loop;
        return "";
   end Get_Day;
   
   function Split_String( Str: String; Pattern: String ) return Split_Str_Arr is
      Pattern_Count: constant Natural := Ada.Strings.Search.Count( Str, Pattern );
      Curr_Idx : Positive := 1;
      type Index_Arr is array( 0 .. Pattern_Count ) of Natural;
      Pattern_Idx_Arr : Index_Arr;
      Arr : Split_Str_Arr( 0 .. Pattern_Count );
   begin
      -- Get all index's of space
      for I in 0 .. Pattern_Count loop
         Pattern_Idx_Arr( I ) := Index( Str, Pattern, Curr_Idx );
         Curr_Idx := Pattern_Idx_Arr( I ) + 1;
      end loop;
      
      -- Reset curr idx to start of string
      Curr_Idx := 1;
      
      -- For each entry except last in pattern, slice array based on location
      for Pattern_Idx in Pattern_Idx_Arr'First .. Pattern_Idx_Arr'Last - 1 loop
         Arr( Pattern_Idx ) := Split_Str_P.To_Bounded_String( Str( Curr_Idx .. Pattern_Idx_Arr( Pattern_Idx ) ) );
         Curr_Idx := Pattern_Idx_Arr( Pattern_Idx ) + 1;
      end loop;
      
      -- Special case to handle the last entry where we get to the end of the string
      Arr( Arr'Last ) := Split_Str_P.To_Bounded_String( Str( Curr_Idx .. Str'Last ) );
      
      return Arr;
   end;
   
   function Get_File_Structure( Input_File: String ) return File_Structure_R is
      File: File_Type;
      FS : File_Structure_R := (Line_Length => 1, Num_Lines => 1);
   begin
      Open( File, In_File, Input_File );
      
      declare
         Str : constant String := Get_Line( File );
      begin
         FS.Line_Length := Str'Last;
      end;
      
      while not End_Of_File( File ) loop
         Skip_Line( File );
         FS.Num_Lines := FS.Num_Lines + 1;
      end loop;
      
      Close( File );
      return FS;
   end Get_File_Structure;
end Utilities;
