with Ada.Command_Line;
package body Utilities is

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
end Utilities;
