unit MiniDelivery.Model.Entidades.Estado;

interface

uses
   SysUtils, Data.DB, System.Json, REST.Json,
   MiniDelivery.Conexao.Interfaces,
   MiniDelivery.Entidades.Interfaces,
   MiniDelivery.Classe.Endereco;

type
   TModelEntidadeEstado = class(TInterfacedObject, IModelEntidade)
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
      function GetEstado(const Id: Integer): TEstado;
      function GetEstados: TListaEstados;
   end;

implementation

uses
   MiniDelivery.Model.Conexao.Factory,
   MiniDelivery.Model.Entidades.Pais,
   MiniDelivery.Model.Entidades.Factory;

{ TModelEntidadeEstado }

constructor TModelEntidadeEstado.Create(const ATipoConexao: TTipoConexao = tcFireDAC);
begin
   fTipoConexao := ATipoConexao;
   fQuery := TModelConexaoFactory.New(fTipoConexao).Query;
end;

function TModelEntidadeEstado.DataSet(const Value: TDataSet): IModelEntidade;
begin
   Result := Self;
   Value.Assign(fQuery.Query);
end;

function TModelEntidadeEstado.DataSet(const Value: TDataSource): IModelEntidade;
begin
   Result := Self;
   Value.DataSet := fQuery.Query;
end;

destructor TModelEntidadeEstado.Destroy;
begin

  inherited;
end;

function TModelEntidadeEstado.GetEstado(const Id: Integer): TEstado;
var
   APaisModel: IModelEntidade;
begin
   Result := TEstado.Create;
   Open(Format('WHERE id = %d', [Id]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            APaisModel := TModelEntidadesFactory.New(fTipoConexao).Pais;
            Result.Id := Query.FieldByName('id').AsInteger;
            Result.Nome := Query.FieldByName('nome').AsString;
            Result.Pais := TModelEntidadePais(APaisModel).GetPais(Query.FieldByName('pais_id').AsInteger);
         end;
end;

function TModelEntidadeEstado.GetEstados: TListaEstados;
var
   AEstado: TEstado;
   APaisModel: IModelEntidade;
begin
   Result := TListaEstados.Create;
   Open();
   with fQuery do
      if not Query.IsEmpty then
         begin
            Query.First;
            APaisModel := TModelEntidadesFactory.New(fTipoConexao).Pais;
            while not Query.Eof do
               begin
                  AEstado := TEstado.Create;
                  AEstado.Id := Query.FieldByName('id').AsInteger;
                  AEstado.Nome := Query.FieldByName('nome').AsString;
                  AEstado.Pais := TModelEntidadePais(APaisModel).GetPais(Query.FieldByName('pais_id').AsInteger);
                  Result.Add(AEstado);
                  Query.Next;
               end;
         end;
end;

class function TModelEntidadeEstado.New(const ATipoConexao: TTipoConexao = tcFireDAC): IModelEntidade;
begin
   Result := Self.Create(ATipoConexao);
end;

procedure TModelEntidadeEstado.Open(const AWhere: String);
var
   ASQL: String;
begin
   ASQL := '';
   ASQL := ASQL + 'SELECT id, nome, pais_id ';
   ASQL := ASQL + 'FROM estados';
   if AWhere <> '' then
      ASQL := ASQL + ' ' + AWhere;
   fQuery.Open(ASQL);
   // Definindo o campo id, como autoincremento
   fQuery.Query.FieldByName('id').AutoGenerateValue := TAutoRefreshFlag.arAutoInc;
end;

end.
