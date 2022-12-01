with Ada.Command_Line;
package body Utilities is

    function Get_Filename return String is
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
    begin
        for i in 1 .. Ada.Command_Line.Argument_Count loop
            if( Ada.Command_Line.Argument(i) = "--day") then
                return Ada.Command_Line.Argument(i+1);
            end if;
        end loop;
        return "Day_1";
    end Get_Day;
end Utilities;
