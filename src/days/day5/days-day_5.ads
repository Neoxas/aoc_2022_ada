with Ada.Containers.Formal_Vectors; use Ada.Containers;
with Ada.Strings.Bounded; use Ada.Strings;

package Days.Day_5 is
   pragma Elaborate_Body;
   MAX_CONTAINTER_STR : constant := 200;
   MAX_INSTRUCTIONS : constant := 200;
   MAX_STACKS : constant := 20;
   
   package Containter_Str_P is new Ada.Strings.Bounded.Generic_Bounded_Length( MAX_CONTAINTER_STR );
   package Container_Vec_P is new Bounded_Vectors;
   
   

end Days.Day_5;
