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
   elsif Day = "6" then
      Run_Day_6(Filename);
    end if;
end Aoc_2022_Ada;
