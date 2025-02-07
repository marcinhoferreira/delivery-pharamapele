unit MiniDelivery.Libraries;

interface

uses
   System.Classes, FMX.Controls;

procedure DeLayedSetFocus(Control: TControl);

implementation

uses
   FMX.Edit, FMX.NumberBox;

procedure DeLayedSetFocus(Control: TControl);
begin
   TThread.CreateAnonymousThread(
      procedure
      begin
         TThread.Synchronize( nil,
            procedure
            begin
               if Control Is TEdit then
                  TEdit(Control).SelectAll();
               if Control Is TNumberBox then
                  TNumberBox(Control).SelectAll();
               Control.SetFocus;
            end
        );
      end
    ).Start;
end;

end.
