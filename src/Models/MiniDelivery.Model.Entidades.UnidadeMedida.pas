unit MiniDelivery.Model.Entidades.UnidadeMedida;

interface

uses
   SysUtils, Data.DB, System.Json, REST.Json,
   MiniDelivery.Conexao.Interfaces,
   MiniDelivery.Entidades.Interfaces,
   MiniDelivery.Classe.UnidadeMedida;

type
   TModelEntidadeUnidadeMedida = class(TInterfacedObject, IModelEntidade)
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
      function GetUnidadeMedida(const Id: Integer): TUnidadeMedida;
      function GetUnidadesMedida: TListaUnidadesMedida;
   end;

implementation

uses
   MiniDelivery.Model.Conexao.Factory;

{ TModelEntidadeUnidadeMedida }

constructor TModelEntidadeUnidadeMedida.Create(const ATipoConexao: TTipoConexao = tcFireDAC);
begin
   fTipoConexao := ATipoConexao;
   fQuery := TModelConexaoFactory.New(fTipoConexao).Query;
end;

function TModelEntidadeUnidadeMedida.DataSet(const Value: TDataSet): IModelEntidade;
begin
   Result := Self;
   Value.Assign(fQuery.Query);
end;

function TModelEntidadeUnidadeMedida.DataSet(const Value: TDataSource): IModelEntidade;
begin
   Result := Self;
   Value.DataSet := fQuery.Query;
end;

destructor TModelEntidadeUnidadeMedida.Destroy;
begin

  inherited;
end;

function TModelEntidadeUnidadeMedida.GetUnidadeMedida(const Id: Integer): TUnidadeMedida;
begin
   Result := TUnidadeMedida.Create;
   Open(Format('WHERE id = %d', [Id]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            Result.Id := Query.FieldByName('id').AsInteger;
            Result.Nome := Query.FieldByName('nome').AsString;
            Result.Sigla := Query.FieldByName('sigla').AsString;
         end;
end;

function TModelEntidadeUnidadeMedida.GetUnidadesMedida: TListaUnidadesMedida;
var
   AUnidadeMedida: TUnidadeMedida;
begin
   Result := TListaUnidadesMedida.Create;
   Open();
   with fQuery do
      if not Query.IsEmpty then
         begin
            Query.First;
            while not Query.Eof do
               begin
                  AUnidadeMedida := TUnidadeMedida.Create;
                  AUnidadeMedida.Id := Query.FieldByName('id').AsInteger;
                  AUnidadeMedida.Nome := Query.FieldByName('nome').AsString;
                  AUnidadeMedida.Sigla := Query.FieldByName('sigla').AsString;
                  Result.Add(AUnidadeMedida);
                  Query.Next;
               end;
         end;
end;

class function TModelEntidadeUnidadeMedida.New(const ATipoConexao: TTipoConexao = tcFireDAC): IModelEntidade;
begin
   Result := Self.Create(ATipoConexao);
end;

procedure TModelEntidadeUnidadeMedida.Open(const AWhere: String);
var
   ASQL: String;
begin
   ASQL := '';
   ASQL := ASQL + 'SELECT id, nome, sigla ';
   ASQL := ASQL + 'FROM unidades_medida';
   if AWhere <> '' then
      ASQL := ASQL + ' ' + AWhere;
   fQuery.Open(ASQL);
   // Definindo o campo id, como autoincremento
   fQuery.Query.FieldByName('id').AutoGenerateValue := TAutoRefreshFlag.arAutoInc;
end;

end.
