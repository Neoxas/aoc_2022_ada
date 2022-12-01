with Days; use Days;
with Utilities; use Utilities;

procedure Aoc_2022_Ada is
    Day : constant String := Get_Day;
    Filename : constant String := Get_Filename;
begin
    if Day = "Day1" then
        Run_Day_1(Filename);
    elsif Day = "Day2" then
        Run_Day_2(Filename);
    end if;
end Aoc_2022_Ada;
