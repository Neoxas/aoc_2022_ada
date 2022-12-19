with Ada.Text_IO; use ADa.Text_IO;
package body Days.Day_11 with SPARK_Mode is
   use Monkey_Map_P;
   use Monkey_Item_Vec_P;

   function Convert_String_To_Worry( Str: String ) return Item_Worry_Level_T is
   begin
      return From_String( Str );
   end;

   procedure Do_Monkey_Operation( Item: Item_Worry_Level_T; Monkey: in out Monkey_R; Monkeys: in out Monkey_Map_P.Map) is
      function Get_Side_Value( Item: Item_Worry_Level_T; Side: Worry_Side_R ) return Item_Worry_Level_T is
      begin
         case Side.Side_Type is
            when Old =>
               return Item;
            when Value =>
               return Side.Side_Val;
         end case;
      end Get_Side_Value;
      Item_Copy: Item_Worry_Level_T := Item;
      Tmp_LHS : constant Item_Worry_Level_T := Get_Side_Value(Item_Copy, Monkey.Item_Op.LHS_Type);
      Tmp_RHS : constant Item_Worry_Level_T := Get_Side_Value(Item_Copy, Monkey.Item_Op.RHS_Type);
   begin
      Put_Line( "Operation :" & Tmp_LHS'Image & Monkey.Item_Op.Operator'Image & Tmp_RHS'Image );
      -- Monkey goes through each item. Inspects it. Adjusts worry level by operator and then div 3 round down.
      case Monkey.Item_Op.Operator is
         when '*' => 
            Item_Copy := Tmp_LHS * Tmp_RHS;
         when '+' =>
            Item_Copy := Tmp_LHS + Tmp_RHS;
         when '-' =>
            Item_Copy := Tmp_LHS - Tmp_RHS;
      end case;
      
      -- Item_Copy := Item_Copy / 3;

      -- Tests and throws to relevant monkey.
      if Item_Copy mod Monkey.Div_Test = 0 then
         declare
            Pass_Monkey: Monkey_R := Element( Monkeys, Monkey.Pass_Monkey );
         begin
            Append( Pass_Monkey.Items, Item_Copy );
            -- Re-assign new monkey
            Include( Monkeys, Monkey.Pass_Monkey, Pass_Monkey );
         end;
      else
         declare
            Fail_Monkey: Monkey_R := Element( Monkeys, Monkey.Fail_Monkey );
         begin
            Append( Fail_Monkey.Items, Item_Copy );
            -- Re-assign new monkey
            Include( Monkeys, Monkey.Fail_Monkey, Fail_Monkey );
         end;
      end if;
      
      Monkey.Items_Inspected := Monkey.Items_Inspected + 1;
   end Do_Monkey_Operation;
   
   function Get_Monkey_Buisness_Level( Monkeys : Monkey_Map_P.Map; Rounds: Positive ) return Natural is
      -- Copy to allow us to adjust entries as we go through rounds
      M_Copy : Monkey_Map_P.Map := Monkeys;
      Inspect_Max_1, Inspect_Max_2 : Natural := 0;
   begin
      -- For up to set round
      for I in 1 .. Rounds loop
         -- Go through each monkey
         for Monkey_Idx of M_Copy loop
            declare
               Monkey : Monkey_R := Element( M_Copy, Monkey_Idx);
            begin
               -- Inspect each item for each monkey
               for Item of Monkey.Items loop
                  -- Do operations on worry levels and throw to other monkeys.
                  Do_Monkey_Operation( Item, Monkey, M_Copy);
               end loop;
               -- Monkey has thrown all its items so it should be empty
               Clear( Monkey.Items );
               -- Re-assign monkey to memory copy.
               Include( M_Copy, Monkey_Idx, Monkey );
            end;
         end loop;
      end loop;
      
      for Monkey_Idx of M_Copy loop
         declare
            Inspected : constant Natural := Element( M_Copy, Monkey_Idx ).Items_Inspected;
         begin
            if Inspected > Inspect_Max_1 then
               Inspect_Max_2 := Inspect_Max_1;
               Inspect_Max_1 := Inspected;
            elsif Inspected > Inspect_Max_2 then
               Inspect_Max_2 := Inspected;
            end if;
         end ;
      end loop;
      return Inspect_Max_1 * Inspect_Max_2;
   end;
end Days.Day_11;
