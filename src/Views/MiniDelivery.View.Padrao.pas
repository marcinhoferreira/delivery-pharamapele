unit MiniDelivery.View.Padrao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmPadrao = class(TForm)
    lytWorkArea: TLayout;
    barToolBar: TToolBar;
    btnMenu: TSpeedButton;
    lblTituloFormulario: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: WideChar;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure DeLayedSetFocus(Control: TControl);

var
  frmPadrao: TfrmPadrao;

implementation

uses
   FMX.Edit, FMX.NumberBox;

{$R *.fmx}

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

{ TfrmPadrao }

procedure TfrmPadrao.FormCreate(Sender: TObject);
begin
   lblTituloFormulario.Text := Caption;
end;

procedure TfrmPadrao.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: WideChar; Shift: TShiftState);
begin
   if Key = vkReturn then
      begin
         Key := vkTab;
         KeyDown(Key, KeyChar, Shift);
      end;
end;

initialization
   RegisterClass(TfrmPadrao);

finalization
   UnRegisterClass(TfrmPadrao);

end.
