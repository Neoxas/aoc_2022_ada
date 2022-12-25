with ADa.Text_IO; use Ada.Text_IO;
package body Days.Day_13 is
   use Signal_Vec_P;
   use Signals_P;
   use All_Signals_P;
   
   type Signal_State_E is ( True, False, Equal );
   
   function Index_In_Vector( Index: Signal_Idx_T; Vec: Signal_Vec_P.Vector) return Boolean is
     ( Index in First_Index( Vec ) .. Last_Index( Vec ) );
   
   function Index_In_Vector( Index: Signal_Idx_T; Vec: Signals_P.Vector) return Boolean is
     ( Index in First_Index( Vec ) .. Last_Index( Vec ) );
   
   function Left_Vs_Right_Signal( Left: Signals_P.Vector; Right: Signals_P.Vector ) return Signal_State_E is
   begin      
      for Left_Idx in Left loop
         -- If the left index is in the right vector, keep going
         -- Else fail as the right vector ran our first.
         if Index_In_Vector( Left_Idx, Right ) then
            -- If left < right, we have a pass so return true
            -- elsif left > right, in the wrong order so return false
            -- Else carry on checking elements.
            if Element( Left, Left_Idx ) < Element( Right, Left_Idx ) then
               return True;
            elsif Element( Left, Left_Idx ) > Element( Right, Left_Idx ) then
               return False;
            end if;
         else
            return False;
         end if;
      end loop;
      
      -- If every IDX is fine, we return true
      return Equal;
   end Left_Vs_Right_Signal;
   
   function Signals_In_Correct_Order( Left: Signal_Vec_P.Vector; Right: Signal_Vec_P.Vector ) return Boolean is
      Result: Signal_State_E := Equal;
   begin
      for Signal_Idx in Right loop
         -- If we have an entry in the left hand side, compare them
         if Index_In_Vector( Signal_Idx, Left ) then
            declare 
               L : constant Signal_List_R := Element( Left, Signal_Idx );
               R : constant Signal_List_R := Element( Right, Signal_Idx );
            begin
               -- If the depths arent equal, then we want to check the length of one of the sides is 1
               if L.Depth /= R.Depth then
                  if Length(R.Signals) <= 1 then
                     if L.Depth < R.Depth  then
                        Result := Left_Vs_Right_Signal(L.Signals, R.Signals);
                     else 
                        Result := False;
                     end if;
                  
                  elsif  Length(L.Signals) <= 1 then
                     if R.Depth < L.Depth  then
                        Result := Left_Vs_Right_Signal(L.Signals, R.Signals);
                     else 
                        Result := False;
                     end if;
                  end if;
                  -- Else if they do existthe same we compare them
               elsif L.Depth = R.Depth then
                  Result := Left_Vs_Right_Signal(L.Signals, R.Signals);
                  -- Catch all failure case
               else
                  Result := False;
               end if;
            end;
            else
               -- Right hand side still has elements whilst left is empty, so pass and exit
               Result := True;
            end if;
         
         -- If we hit a false, exit the loop
         case Result is
            when True => return True;
            when False => return False;
            when Equal => null;
         end case;
      end loop;
      -- Want to pop entry off list.
      -- Check they are correct depth
      -- Whilst going through, we want to compare left element to right element
      -- If left > right => Fail
      -- If Right runs out before left => Fail
      -- else => Pass
      return True;
   end Signals_In_Correct_Order;

   function Count_Correct_Signals( Signals: All_Signals_P.Vector ) return Natural is
      Idx_Sum: Natural := 0;
   begin
      for Signals_Idx in Signals loop
         if Signals_In_Correct_Order( Element(Signals, Signals_Idx).Left, Element(Signals, Signals_Idx).Right ) then
            Put_Line( "Index : " & Signals_Idx'Image & " in correct order" );
            Idx_Sum := Idx_Sum + Signals_Idx;
         end if;
      end loop;
         
      return Idx_Sum;
   end Count_Correct_Signals;
   
end Days.Day_13;
