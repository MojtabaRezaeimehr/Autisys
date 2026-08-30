unit uJalaliCalendar;

interface

procedure DateToJalaali(const ADate: TDateTime; var Year, Month, Day: Integer);
function JalaaliToDate(Year, Month, Day: Integer): TDateTime;

implementation

const
  JALALI_EPOCH = 1948321;

procedure DateToJalaali(const ADate: TDateTime; var Year, Month, Day: Integer);
var
  jd, depoch, cycle, cyear, ycycle: Integer;
  mm, dayOfYear: Integer;
begin
  jd := Trunc(ADate) + 32044;

  depoch := jd - JALALI_EPOCH;
  cycle := depoch div 1029983;
  cyear := depoch mod 1029983;

  if cyear = 1029982 then
    cycle := cycle + 1;

  ycycle := 2826 * cycle + 1108;
  if cyear < 366 then
  begin
    ycycle := ycycle + (cyear div 365);
    cyear := cyear mod 365;
  end;

  Year := ycycle + 474;
  if Year <= 0 then
    Year := Year - 1;

  dayOfYear := (cycle * 366) + cyear;
  mm := (dayOfYear div 120) + 3;
  Month := mm mod 12 + 1;
  Day := (dayOfYear mod 365) + 1;
end;

function JalaaliToDate(Year, Month, Day: Integer): TDateTime;
var
  jd, depoch, cycle, cyear, ycycle: Integer;
  mm: Integer;
begin
  if Year <= 0 then
    Year := Year + 1;

  depoch := (Year - 474) div 2820 * 1029983 + (Year - 474) mod 2820 * 365 - 1;
  cycle := depoch div 1029983;
  cyear := depoch mod 1029983;

  if cyear = 1029982 then
    cycle := cycle + 1;

  ycycle := 2826 * cycle + 1108;
  if cyear < 366 then
  begin
    ycycle := ycycle + (cyear div 365);
    cyear := cyear mod 365;
  end;

  jd := JALALI_EPOCH + 365 * (Year - 474) + (ycycle div 2820) * 1029983 + ycycle;

  mm := (Month - 1) div 6 + 4;
  jd := jd + (Month - 1) * 31 - (mm div 12) * (Month - 1);
  jd := jd + Day - 1;

  Result := jd - 32044;
end;
end.
