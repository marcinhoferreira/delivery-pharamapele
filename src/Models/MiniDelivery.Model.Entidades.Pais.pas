unit MiniDelivery.Model.Entidades.Pais;

interface

uses
   SysUtils, Data.DB, System.Json, REST.Json,
   MiniDelivery.Conexao.Interfaces,
   MiniDelivery.Entidades.Interfaces,
   MiniDelivery.Classe.Endereco;

type
   TModelEntidadePais = class(TInterfacedObject, IModelEntidade)
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
      function GetPais(const Id: Integer): TPais;
      function GetPaises: TListaPaises;
   end;

implementation

uses
   MiniDelivery.Model.Conexao.Factory;

{ TModelEntidadePais }

constructor TModelEntidadePais.Create(const ATipoConexao: TTipoConexao = tcFireDAC);
begin
   fTipoConexao := ATipoConexao;
   fQuery := TModelConexaoFactory.New(fTipoConexao).Query;
end;

function TModelEntidadePais.DataSet(const Value: TDataSet): IModelEntidade;
begin
   Result := Self;
   Value.Assign(fQuery.Query);
end;

function TModelEntidadePais.DataSet(const Value: TDataSource): IModelEntidade;
begin
   Result := Self;
   Value.DataSet := fQuery.Query;
end;

destructor TModelEntidadePais.Destroy;
begin

  inherited;
end;

function TModelEntidadePais.GetPais(const Id: Integer): TPais;
begin
   Result := TPais.Create;
   Open(Format('WHERE id = %d', [Id]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            Result.Id := Query.FieldByName('id').AsInteger;
            Result.Nome := Query.FieldByName('nome').AsString;
         end;
end;

function TModelEntidadePais.GetPaises: TListaPaises;
var
   APais: TPais;
begin
   Result := TListaPaises.Create;
   Open();
   with fQuery do
      if not Query.IsEmpty then
         begin
            Query.First;
            while not Query.Eof do
               begin
                  APais := TPais.Create;
                  APais.Id := Query.FieldByName('id').AsInteger;
                  APais.Nome := Query.FieldByName('nome').AsString;
                  Result.Add(APais);
                  Query.Next;
               end;
         end;
end;

class function TModelEntidadePais.New(const ATipoConexao: TTipoConexao = tcFireDAC): IModelEntidade;
begin
   Result := Self.Create(ATipoConexao);
end;

procedure TModelEntidadePais.Open(const AWhere: String);
var
   ASQL: String;
begin
   ASQL := '';
   ASQL := ASQL + 'SELECT id, nome ';
   ASQL := ASQL + 'FROM paises';
   if AWhere <> '' then
      ASQL := ASQL + ' ' + AWhere;
   fQuery.Open(ASQL);
   // Definindo o campo id, como autoincremento
   fQuery.Query.FieldByName('id').AutoGenerateValue := TAutoRefreshFlag.arAutoInc;
end;

end.
