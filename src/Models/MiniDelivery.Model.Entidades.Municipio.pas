unit MiniDelivery.Model.Entidades.Municipio;

interface

uses
   SysUtils, Data.DB, System.Json, REST.Json,
   MiniDelivery.Conexao.Interfaces,
   MiniDelivery.Entidades.Interfaces,
   MiniDelivery.Classe.Endereco;

type
   TModelEntidadeMunicipio = class(TInterfacedObject, IModelEntidade)
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
      function GetMunicipio(const Id: Integer): TMunicipio;
      function GetMunicipios: TListaMunicipios;
   end;

implementation

uses
   MiniDelivery.Model.Conexao.Factory,
   MiniDelivery.Model.Entidades.Estado,
   MiniDelivery.Model.Entidades.Factory;

{ TModelEntidadeMunicipio }

constructor TModelEntidadeMunicipio.Create(const ATipoConexao: TTipoConexao = tcFireDAC);
begin
   fTipoConexao := ATipoConexao;
   fQuery := TModelConexaoFactory.New(fTipoConexao).Query;
end;

function TModelEntidadeMunicipio.DataSet(const Value: TDataSet): IModelEntidade;
begin
   Result := Self;
   Value.Assign(fQuery.Query);
end;

function TModelEntidadeMunicipio.DataSet(const Value: TDataSource): IModelEntidade;
begin
   Result := Self;
   Value.DataSet := fQuery.Query;
end;

destructor TModelEntidadeMunicipio.Destroy;
begin

  inherited;
end;

function TModelEntidadeMunicipio.GetMunicipio(const Id: Integer): TMunicipio;
var
   AEstadoModel: IModelEntidade;
begin
   Result := TMunicipio.Create;
   Open(Format('WHERE id = %d', [Id]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            AEstadoModel := TModelEntidadesFactory.New(fTipoConexao).Estado;
            Result.Id := Query.FieldByName('id').AsInteger;
            Result.Nome := Query.FieldByName('nome').AsString;
            Result.Estado := TModelEntidadeEstado(AEstadoModel).GetEstado(Query.FieldByName('estado_id').AsInteger);
         end;
end;

function TModelEntidadeMunicipio.GetMunicipios: TListaMunicipios;
var
   AMunicipio: TMunicipio;
   AEstadoModel: IModelEntidade;
begin
   Result := TListaMunicipios.Create;
   Open();
   with fQuery do
      if not Query.IsEmpty then
         begin
            Query.First;
            AEstadoModel := TModelEntidadesFactory.New(fTipoConexao).Estado;
            while not Query.Eof do
               begin
                  AMunicipio := TMunicipio.Create;
                  AMunicipio.Id := Query.FieldByName('id').AsInteger;
                  AMunicipio.Nome := Query.FieldByName('nome').AsString;
                  AMunicipio.Estado := TModelEntidadeEstado(AEstadoModel).GetEstado(Query.FieldByName('estado_id').AsInteger);
                  Result.Add(AMunicipio);
                  Query.Next;
               end;
         end;
end;

class function TModelEntidadeMunicipio.New(const ATipoConexao: TTipoConexao = tcFireDAC): IModelEntidade;
begin
   Result := Self.Create(ATipoConexao);
end;

procedure TModelEntidadeMunicipio.Open(const AWhere: String);
var
   ASQL: String;
begin
   ASQL := '';
   ASQL := ASQL + 'SELECT id, nome, estado_id ';
   ASQL := ASQL + 'FROM municipios';
   if AWhere <> '' then
      ASQL := ASQL + ' ' + AWhere;
   fQuery.Open(ASQL);
   // Definindo o campo id, como autoincremento
   fQuery.Query.FieldByName('id').AutoGenerateValue := TAutoRefreshFlag.arAutoInc;
end;

end.
