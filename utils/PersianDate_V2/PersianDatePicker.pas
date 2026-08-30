unit FMX.PersianDatePicker;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, FMX.Controls, FMX.StdCtrls,
  FMX.Edit, FMX.Types, FMX.ListBox;

type
  TFMXPersianDatePicker = class(TFrame)
    YearCombo: TComboBox;
    MonthCombo: TComboBox;
    DayCombo: TComboBox;
    Layout1: TLayout;
  private
    FYear: Integer;
    FMonth: Integer;
    FDay: Integer;
    FOnChange: TNotifyEvent;
    FUseFullMonthNames: Boolean;

    procedure SetYear(Value: Integer);
    procedure SetMonth(Value: Integer);
    procedure SetDay(Value: Integer);
    procedure SetUseFullMonthNames(Value: Boolean);

    procedure YearComboChange(Sender: TObject);
    procedure MonthComboChange(Sender: TObject);
    procedure DayComboChange(Sender: TObject);

    function GetPersianDate: string;
    procedure SetPersianDate(const Value: string);

    function IsLeapYear(Year: Integer): Boolean;
    function GetMonthDays(Year, Month: Integer): Integer;
    procedure UpdateDayCombo;
    procedure PopulateCombos;
    procedure DoChange;

  public
    constructor Create(AOwner: TComponent); override;

    procedure SetCurrentDate;
    procedure Clear;

    property PersianDate: string read GetPersianDate write SetPersianDate;

  published
    property Year: Integer read FYear write SetYear;
    property Month: Integer read FMonth write SetMonth;
    property Day: Integer read FDay write SetDay;
    property UseFullMonthNames: Boolean read FUseFullMonthNames
      write SetUseFullMonthNames;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

procedure Register;

implementation

const
  PersianMonthNames: array [1 .. 12] of string = ('فروردین', 'اردیبهشت',
    'خرداد', 'تیر', 'مرداد', 'شهریور', 'مهر', 'آبان', 'آذر', 'دی',
    'بهمن', 'اسفند');

procedure Register;
begin
  RegisterComponents('Persian FMX', [TFMXPersianDatePicker]);
end;

{ TFMXPersianDatePicker }

constructor TFMXPersianDatePicker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  Width := 350;
  Height := 32;

  // Layout
  Layout1 := TLayout.Create(Self);
  Layout1.Parent := Self;
  Layout1.Align := TAlignLayout.Client;
  Layout1.Margins.Top := 4;
  Layout1.Margins.Bottom := 4;

  // Year ComboBox
  YearCombo := TComboBox.Create(Self);
  YearCombo.Parent := Layout1;
  YearCombo.Position.X := 0;
  YearCombo.Position.Y := 0;
  YearCombo.Width := 80;
  YearCombo.Height := 24;
  YearCombo.OnChange := YearComboChange;

  // Month ComboBox
  MonthCombo := TComboBox.Create(Self);
  MonthCombo.Parent := Layout1;
  MonthCombo.Position.X := 85;
  MonthCombo.Position.Y := 0;
  MonthCombo.Width := 90;
  MonthCombo.Height := 24;
  MonthCombo.OnChange := MonthComboChange;

  // Day ComboBox
  DayCombo := TComboBox.Create(Self);
  DayCombo.Parent := Layout1;
  DayCombo.Position.X := 180;
  DayCombo.Position.Y := 0;
  DayCombo.Width := 70;
  DayCombo.Height := 24;
  DayCombo.OnChange := DayComboChange;

  FUseFullMonthNames := False;
  FYear := 1400;
  FMonth := 1;
  FDay := 1;

  PopulateCombos;
end;

function TFMXPersianDatePicker.IsLeapYear(Year: Integer): Boolean;
var
  R: Integer;
begin
  R := Year mod 33;
  Result := (R = 1) or (R = 5) or (R = 9) or (R = 13) or (R = 17) or (R = 22) or
    (R = 26) or (R = 30);
end;

function TFMXPersianDatePicker.GetMonthDays(Year, Month: Integer): Integer;
begin
  if Month <= 6 then
    Result := 31
  else if Month <= 11 then
    Result := 30
  else if IsLeapYear(Year) then
    Result := 30
  else
    Result := 29;
end;

procedure TFMXPersianDatePicker.UpdateDayCombo;
var
  I, MaxDays: Integer;
  CurrentDay: Integer;
begin
  CurrentDay := DayCombo.ItemIndex + 1;
  MaxDays := GetMonthDays(FYear, FMonth);

  DayCombo.Items.Clear;
  for I := 1 to MaxDays do
    DayCombo.Items.Add(I.ToString);

  if CurrentDay > MaxDays then
    CurrentDay := MaxDays;

  if DayCombo.Items.Count > 0 then
    DayCombo.ItemIndex := CurrentDay - 1;

  FDay := DayCombo.ItemIndex + 1;
end;

procedure TFMXPersianDatePicker.PopulateCombos;
var
  I: Integer;
begin
  // Year
  YearCombo.Items.Clear;
  for I := 1300 to 1500 do
    YearCombo.Items.Add(I.ToString);
  YearCombo.ItemIndex := FYear - 1300;

  // Month
  MonthCombo.Items.Clear;
  for I := 1 to 12 do
  begin
    if FUseFullMonthNames then
      MonthCombo.Items.Add(PersianMonthNames[I])
    else
      MonthCombo.Items.Add(I.ToString);
  end;
  MonthCombo.ItemIndex := FMonth - 1;

  // Day
  UpdateDayCombo;
end;

procedure TFMXPersianDatePicker.SetYear(Value: Integer);
begin
  if (Value >= 1300) and (Value <= 1500) then
  begin
    FYear := Value;
    if YearCombo.Items.Count > 0 then
      YearCombo.ItemIndex := FYear - 1300;
    UpdateDayCombo;
    DoChange;
  end;
end;

procedure TFMXPersianDatePicker.SetMonth(Value: Integer);
begin
  if (Value >= 1) and (Value <= 12) then
  begin
    FMonth := Value;
    if MonthCombo.Items.Count > 0 then
      MonthCombo.ItemIndex := FMonth - 1;
    UpdateDayCombo;
    DoChange;
  end;
end;

procedure TFMXPersianDatePicker.SetDay(Value: Integer);
var
  MaxDays: Integer;
begin
  MaxDays := GetMonthDays(FYear, FMonth);
  if (Value >= 1) and (Value <= MaxDays) then
  begin
    FDay := Value;
    if DayCombo.Items.Count > 0 then
      DayCombo.ItemIndex := FDay - 1;
    DoChange;
  end;
end;

procedure TFMXPersianDatePicker.SetUseFullMonthNames(Value: Boolean);
begin
  FUseFullMonthNames := Value;
  PopulateCombos;
end;

procedure TFMXPersianDatePicker.YearComboChange(Sender: TObject);
begin
  if YearCombo.ItemIndex >= 0 then
  begin
    FYear := YearCombo.ItemIndex + 1300;
    UpdateDayCombo;
    DoChange;
  end;
end;

procedure TFMXPersianDatePicker.MonthComboChange(Sender: TObject);
begin
  if MonthCombo.ItemIndex >= 0 then
  begin
    FMonth := MonthCombo.ItemIndex + 1;
    UpdateDayCombo;
    DoChange;
  end;
end;

procedure TFMXPersianDatePicker.DayComboChange(Sender: TObject);
begin
  if DayCombo.ItemIndex >= 0 then
  begin
    FDay := DayCombo.ItemIndex + 1;
    DoChange;
  end;
end;

procedure TFMXPersianDatePicker.DoChange;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

function TFMXPersianDatePicker.GetPersianDate: string;
begin
  Result := Format('%.4d/%.2d/%.2d', [FYear, FMonth, FDay]);
end;

procedure TFMXPersianDatePicker.SetPersianDate(const Value: string);
var
  Y, M, D: Integer;
begin
  if TryStrToInt(Copy(Value, 1, 4), Y) and TryStrToInt(Copy(Value, 6, 2), M) and
    TryStrToInt(Copy(Value, 9, 2), D) then
  begin
    SetYear(Y);
    SetMonth(M);
    SetDay(D);
  end;
end;

procedure TFMXPersianDatePicker.SetCurrentDate;
begin
  FYear := 1403;
  FMonth := 1;
  FDay := 1;
  PopulateCombos;
  DoChange;
end;

procedure TFMXPersianDatePicker.Clear;
begin
  FYear := 1300;
  FMonth := 1;
  FDay := 1;
  PopulateCombos;
  DoChange;
end;

end.procedure Register; begin RegisterComponents
('Persian', [TPersianDatePicker]); end;

end.
