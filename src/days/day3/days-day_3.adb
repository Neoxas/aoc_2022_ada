package body Days.Day_3 with SPARK_Mode is
   
   type Lower_Lookup_T is array( Character range 'a' .. 'z' ) of Natural;
   Lower_Lookup : constant Lower_Lookup_T := (  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 
                                                11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                                                21, 22, 23, 24, 25, 26);
   type Upper_Lookup_T is array( Character range 'A' .. 'Z' ) of Natural;
   Upper_Lookup : constant Upper_Lookup_T := ( 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37,
                                               38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48,
                                               49, 50, 51, 52);
                                               

   
   function Split_Backpack_Contents( Backpack : Contents_Str_P.Bounded_String ) return Compartments_T is
   begin
      return ( 
               Compartment_1 => Bounded_Slice( Backpack , 1 , Length( Backpack ) / 2 ),
               Compartment_2 => Bounded_Slice( Backpack, (Length(Backpack) / 2) + 1 , Length(Backpack) ) );
   end Split_Backpack_Contents;
      
            
   function Get_Value_Of_Backpack ( Backpack: Contents_Str_P.Bounded_String ) return Natural is 
      function Get_Matching_Char( Compartments : Compartments_T ) return Character is
         Char : Character := ' ';
      begin
         for Comp_1_Idx in 1 .. Length(Compartments.Compartment_1) loop
            Char := Element( Compartments.Compartment_1, Comp_1_Idx );
            for Comp_2_Idx in 1 .. Length( Compartments.Compartment_2 ) loop
               if Char = Element( Compartments.Compartment_2, Comp_2_Idx ) then
                  return Char;
               end if;
            end loop;
         end loop;
         return Char;
      end Get_Matching_Char;
      
      Char : constant Character := Get_Matching_Char( Split_Backpack_Contents( Backpack ));
   begin
      if Char in Lower_Lookup'Range then
         return Lower_Lookup( Char );
      elsif Char in Upper_Lookup'Range then
         return Upper_Lookup( Char );
      else
         return 0;
      end if;
   end Get_Value_Of_Backpack;
   
   function Get_Value_Of_Backpacks( Backpacks : Backpacks_P.Vector ) return Natural is
      Result : Natural := 0;
   begin
      for Backpack of Backpacks loop
         Result := Result + Get_Value_Of_Backpack( Backpack );
      end loop;
      return Result;
   end Get_Value_Of_Backpacks;

end Days.Day_3;
