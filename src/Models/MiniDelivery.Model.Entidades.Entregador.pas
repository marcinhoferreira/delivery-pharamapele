unit MiniDelivery.Model.Entidades.Entregador;

interface

uses
   SysUtils, Data.DB, System.Json, REST.Json,
   MiniDelivery.Conexao.Interfaces,
   MiniDelivery.Entidades.Interfaces,
   MiniDelivery.Classe.Entregador;

type
   TModelEntidadeEntregador = class(TInterfacedObject, IModelEntidade)
   private
      { Private declarations }
      fTipoConexao: TTipoConexao;
      fQuery: IModelQuery;
   public
      { Public declarations }
      constructor Create(const ATipoConexao: TTipoConexao = tcFireDAC);
      destructor Destroy; override;
      class function New(const ATipoConexao: TTipoConexao = tcFireDAC): IModelEntidade;
      function DataSet(const Value: TDataSource): IModelEntidade; overload;
      function DataSet(const Value: TDataSet): IModelEntidade; overload;
      procedure Open(const AWhere: String = '');
      function GetEntregador(const Id: Integer): TEntregador;
      function GetEntregadores: TListaEntregadores;
   end;

implementation

uses
   MiniDelivery.Model.Conexao.Factory;

{ TModelEntidadeEntregador }

constructor TModelEntidadeEntregador.Create(const ATipoConexao: TTipoConexao = tcFireDAC);
begin
   fTipoConexao := ATipoConexao;
   fQuery := TModelConexaoFactory.New(fTipoConexao).Query;
end;

function TModelEntidadeEntregador.DataSet(const Value: TDataSet): IModelEntidade;
begin
   Result := Self;
   Value.Assign(fQuery.Query);
end;

function TModelEntidadeEntregador.DataSet(const Value: TDataSource): IModelEntidade;
begin
   Result := Self;
   Value.DataSet := fQuery.Query;
end;

destructor TModelEntidadeEntregador.Destroy;
begin

  inherited;
end;

function TModelEntidadeEntregador.GetEntregador(const Id: Integer): TEntregador;
begin
   Result := TEntregador.Create;
   Open(Format('WHERE id = %d', [Id]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            Result.Id := Query.FieldByName('id').AsInteger;
            Result.Nome := Query.FieldByName('nome').AsString;
         end;
end;

function TModelEntidadeEntregador.GeTEntregadores: TListaEntregadores;
var
   AEntregador: TEntregador;
begin
   Result := TListaEntregadores.Create;
   Open();
   with fQuery do
      if not Query.IsEmpty then
         begin
            Query.First;
            while not Query.Eof do
               begin
                  AEntregador := TEntregador.Create;
                  AEntregador.Id := Query.FieldByName('id').AsInteger;
                  AEntregador.Nome := Query.FieldByName('nome').AsString;
                  Result.Add(AEntregador);
                  Query.Next;
               end;
         end;
end;

class function TModelEntidadeEntregador.New(const ATipoConexao: TTipoConexao = tcFireDAC): IModelEntidade;
begin
   Result := Self.Create(ATipoConexao);
end;

procedure TModelEntidadeEntregador.Open(const AWhere: String);
var
   ASQL: String;
begin
   ASQL := '';
   ASQL := ASQL + 'SELECT id, nome ';
   ASQL := ASQL + 'FROM entregadores ';
   if AWhere <> '' then
      ASQL := ASQL + AWhere + ' ';
   ASQL := ASQL + 'ORDER BY nome';
   fQuery.Open(ASQL);
   // Definindo o campo id, como autoincremento
   fQuery.Query.FieldByName('id').AutoGenerateValue := TAutoRefreshFlag.arAutoInc;
end;

end.
