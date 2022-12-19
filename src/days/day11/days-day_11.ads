with Ada.Containers.Formal_Vectors;
with Ada.Containers.Formal_Hashed_Maps;

package Days.Day_11 with SPARK_Mode is
   use Ada.Containers;
   
   -- Max number of items a monkey can hold
   MONKEY_ITEM_CAP : constant := 20;
   type Monkey_Item_Idx_T is range 1 .. MONKEY_ITEM_CAP;
   
   -- Define a fixed range for the allowed worry level of an item
   type Item_Worry_Level_T is range 0 .. 100_000;
   
   -- Max of up to 20 monkeys
   type Monkey_ID_T is range 0 .. 20;
   
   -- Operations the monkey can perform on worry level
   type Monkey_Op_E is ('*','+','-');
   -- Allowed value for operator
   type Side_Type_E is (Old, Value);
   
   -- Side of operator can either be Old value or fixed value
   -- Discriminant allows for fixed value to be set
   type Worry_Side_R( Side_Type: Side_Type_E:= Value ) is record
      case Side_Type is
         when Old => null;
         when Value =>
            Side_Val: Integer;
      end case;
   end record;
   
   -- Operation on the worry state is combo of LHS, RHS and operator
   type Worry_Op_R is record
      LHS_Type : Worry_Side_R;
      Operator : Monkey_Op_E;
      RHS_Type : Worry_Side_R;
   end record;
   
   -- Vector for storing item worry levels
   package Monkey_Item_Vec_P is new Formal_Vectors( Index_Type => Monkey_Item_Idx_T,
                                                    Element_Type => Item_Worry_Level_T);
   
   -- Definition of a monkey
   type Monkey_R is record
      -- Items held
      Items : Monkey_Item_Vec_P.Vector(MONKEY_ITEM_CAP);
      -- Operatition it applies to worry level
      Item_Op: Worry_Op_R;
      -- Its test for each worry level
      Div_Test: Positive;
      -- Monkey ID to throw to on Pass/Fail
      Pass_Monkey : Monkey_ID_T;
      Fail_Monkey: Monkey_ID_T;
   end record;
   
   -- Hash method for Monkey ID type
   function Monkey_ID_Hash( ID: Monkey_ID_T ) return Hash_Type is
     ( Hash_Type( ID ) );
   
   -- Dictionary for each monkey.
   package Monkey_Map_P is new Formal_Hashed_Maps( Key_Type => Monkey_ID_T,
                                                   Element_Type => Monkey_R,
                                                   Hash => Monkey_ID_Hash);
   
   function Get_Monkey_Buisness_Level( Monkeys: Monkey_Map_P.Map; Rounds: Positive ) return Natural;
end Days.Day_11;
