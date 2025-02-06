unit MiniDelivery.Model.Conexao.FireDAC.Conexao;

interface

uses
  SysUtils, Classes,
  MiniDelivery.Conexao.Interfaces,
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.FBDef, FireDAC.Phys.FB;

type
   TModelConexaoFireDACConexao = class(TInterfacedObject, IModelConexao)
   private
      { Private declarations }
      fDriverLink: TFDPhysFBDriverLink;
      fConexao: TFDConnection;
   protected
      { Protected declarations }
   public
      { Public declarations }
      constructor Create;
      destructor Destroy; override;
      class function New: IModelConexao;
      function GetDriverName: String;
      function Connection: TObject;
   end;

implementation

uses
   System.IOUtils;

{ TModelConexaoFireDACConexao }

function TModelConexaoFireDACConexao.Connection: TObject;
begin
   Result := fConexao;
end;

constructor TModelConexaoFireDACConexao.Create;
var
   AHomePath: String;
begin
   AHomePath := ExtractFilePath(ParamStr(0));
   fDriverLink := TFDPhysFBDriverLink.Create(Nil);
   fDriverLink.VendorHome := TPath.Combine(AHomePath, 'Lib');
   fConexao := TFDConnection.Create(Nil);
   with fConexao do
      begin
         Params.DriverID := 'FB';
         Params.Values['Server'] := 'localhost';
         Params.Values['Port'] := '3050';
         Params.DataBase := TPath.Combine(TPath.Combine(AHomePath, 'Banco'), 'dados.fdb');
         Params.UserName := 'SYSDBA';
         Params.Password := 'masterkey';
         try
            Connected := True;
         except
            on E: Exception do
               raise Exception.Create('O seguinte erro ocorreu ao tentar estabelecer uma conexão com o host:'#10 + E.Message);
         end;
      end;
end;

destructor TModelConexaoFireDACConexao.Destroy;
begin
   FreeAndNil(fConexao);
   FreeAndNil(fDriverLink);
   inherited;
end;

function TModelConexaoFireDACConexao.GetDriverName: String;
begin
   Result := fConexao.DriverName;
end;

class function TModelConexaoFireDACConexao.New: IModelConexao;
begin
   Result := Self.Create;
end;

end.

