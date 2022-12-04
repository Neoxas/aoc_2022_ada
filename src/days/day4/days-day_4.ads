package Days.Day_4 is

   type Elf_R is record
      Start : Natural;
      Finish : Natural;
   end record with 
     Predicate => ( Finish > Start );

end Days.Day_4;
