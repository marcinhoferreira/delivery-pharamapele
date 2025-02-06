unit MiniDelivery.Model.Conexao.Factory;

interface

uses
  SysUtils, Classes,
  MiniDelivery.Conexao.Interfaces;

type
   TModelConexaoFactory = class(TInterfacedObject, IModelConexaoFactory)
   private
      { Private declarations }
      fTipoConexao: TTipoConexao;
      fConexao: IModelConexao;
   protected
      { Protected declarations }
   public
      { Public declarations }
      constructor Create(const ATipoConexao: TTipoConexao = tcFireDAC);
      destructor Destroy; override;
      class function New(const ATipoConexao: TTipoConexao = tcFireDAC): IModelConexaoFactory;
      function Conexao: IModelConexao;
      function Query: IModelQuery;
      function StoredProc: IModelStoredProc;
   end;

implementation

uses
  MiniDelivery.Model.Conexao.FireDAC.Conexao,
  MiniDelivery.Model.Conexao.FireDAC.Query,
  MiniDelivery.Model.Conexao.FireDAC.StoredProc;

{ TModelConexaoFactory }

function TModelConexaoFactory.Conexao: IModelConexao;
begin
   Result := fConexao;
end;

constructor TModelConexaoFactory.Create(const ATipoConexao: TTipoConexao = tcFireDAC);
begin
   fTipoConexao := ATipoConexao;
   case fTipoConexao of
      tcFireDAC: fConexao := TModelConexaoFireDACConexao.New;
      else
         raise Exception.Create('Tipo de Coneão não suportado!');
   end;
end;

destructor TModelConexaoFactory.Destroy;
begin

  inherited;
end;

class function TModelConexaoFactory.New(const ATipoConexao: TTipoConexao = tcFireDAC): IModelConexaoFactory;
begin
   Result := Self.Create(ATipoConexao);
end;

function TModelConexaoFactory.Query: IModelQuery;
begin
   case fTipoConexao of
      tcFireDAC: Result := TModelConexaoFireDACQuery.New(Self.Conexao);
      else
         raise Exception.Create('Tipo de Coneão não suportado!');
   end;
end;

function TModelConexaoFactory.StoredProc: IModelStoredProc;
begin
   case fTipoConexao of
      tcFireDAC: Result := TModelConexaoFireDACStoredProc.New(Self.Conexao);
      else
         raise Exception.Create('Tipo de Coneão não suportado!');
   end;
end;

end.

