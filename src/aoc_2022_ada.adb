with Days; use Days;
with Utilities; use Utilities;

procedure Aoc_2022_Ada is
    Day : constant String := Get_Day;
    Filename : constant String := Get_Filename;
begin
    if Day = "1" then
        Run_Day_1(Filename);
    elsif Day = "2" then
        Run_Day_2(Filename);
    elsif Day = "3" then
        Run_Day_3(Filename);
    elsif Day = "4" then
        Run_Day_4(Filename);
    elsif Day = "5" then
        Run_Day_5(Filename);
   elsif Day = "6" then
      Run_Day_6(Filename);
   elsif Day = "8" then
      Run_Day_8(Filename);
   elsif Day = "9" then
      Run_Day_9(Filename);
   elsif Day = "10" then
      Run_Day_10(Filename);
   elsif Day = "11" then
      Run_Day_11(Filename);
   elsif Day = "12" then
      Run_Day_12(Filename);
   elsif Day = "13" then
      Run_Day_13(Filename);
   elsif Day = "14" then
      Run_Day_14(Filename);
    end if;
end Aoc_2022_Ada;
