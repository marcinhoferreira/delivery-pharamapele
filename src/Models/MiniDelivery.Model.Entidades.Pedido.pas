unit MiniDelivery.Model.Entidades.Pedido;

interface

uses
   SysUtils, Data.DB,
   MiniDelivery.Conexao.Interfaces,
   MiniDelivery.Entidades.Interfaces,
   MiniDelivery.Classe.Produto,
   MiniDelivery.Classe.Pedido;

type
   TModelEntidadePedido = class(TInterfacedObject, IModelEntidade)
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
      function GetPedidoElaboracao: TPedido;
      function GetPedido(const Id: Integer): TPedido;
      function GetPedidos: TListaPedidos;
      function CriaPedido: TPedido;
      procedure FinalizaPedido(const Pedido: TPedido);
   end;

implementation

uses
   MiniDelivery.Model.Conexao.Factory,
   MiniDelivery.Model.Entidades.Factory,
   MiniDelivery.Model.Entidades.Produto,
   MiniDelivery.Model.Entidades.Municipio,
   MiniDelivery.Model.Entidades.ItemPedido;

{ TModelEntidadePedido }

constructor TModelEntidadePedido.Create(const ATipoConexao: TTipoConexao = tcFireDAC);
begin
   fTipoConexao := ATipoConexao;
   fQuery := TModelConexaoFactory.New(fTipoConexao).Query;
end;

Function TModelEntidadePedido.CriaPedido: TPedido;
begin
   Result := TPedido.Create;
   with fQuery do
      begin
         if Query.IsEmpty then
            begin
               Query.Append;
               Query.FieldByName('situacao').AsInteger := 1;
               Query.Post;
            end;
         Result := GetPedido(Query.FieldByName('id').AsInteger);
      end;
end;

function TModelEntidadePedido.DataSet(const Value: TDataSet): IModelEntidade;
begin
   Result := Self;
   Value.Assign(fQuery.Query);
end;

function TModelEntidadePedido.DataSet(const Value: TDataSource): IModelEntidade;
begin
   Result := Self;
   Value.DataSet := fQuery.Query;
end;

destructor TModelEntidadePedido.Destroy;
begin

  inherited;
end;

procedure TModelEntidadePedido.FinalizaPedido(const Pedido: TPedido);
begin
   Open(Format('WHERE id = %d', [Pedido.Id]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            Query.Edit;
            Query.FieldByName('nome').AsString := Pedido.Nome;
            Query.FieldByName('situacao').AsInteger := 2;
            Query.Post;
         end;
end;

function TModelEntidadePedido.GetPedido(const Id: Integer): TPedido;
var
   AMunicipioModel: IModelEntidade;
begin
   Result := TPedido.Create;
   Open(Format('WHERE id = %d', [Id]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            AMunicipioModel := TModelEntidadesFactory.New(fTipoConexao).Municipio;
            Result.Id := Query.FieldByName('id').AsInteger;
            Result.Nome := Query.FieldByName('nome_cliente').AsString;
            Result.Endereco.Cep := Query.FieldByName('endereco_cep').AsString;
            Result.Endereco.Rua := Query.FieldByName('endereco_rua').AsString;
            Result.Endereco.Numero := Query.FieldByName('endereco_numero').AsString;
            Result.Endereco.Bairro := Query.FieldByName('endereco_bairro').AsString;
            Result.Endereco.Municipio := TModelEntidadeMunicipio(AMunicipioModel).GetMunicipio(Query.FieldByName('endereco_municipio_id').AsInteger);
            if Query.FieldByName('situacao').AsInteger = 1 then
               Result.Situacao := 'Elaboração'
            else if Query.FieldByName('situacao').AsInteger = 2 then
                    Result.Situacao := 'Entrega Pendente'
            else if Query.FieldByName('situacao').AsInteger = 3 then
                    Result.Situacao := 'Entregue';
         end;
end;

function TModelEntidadePedido.GetPedidoElaboracao: TPedido;
begin
   Result := TPedido.Create;
   Open('WHERE situacao = 1');
   with fQuery do
      begin
         if Query.IsEmpty then
            Result := CriaPedido
         else
            Result := GetPedido(Query.FieldByName('id').AsInteger);
      end;
end;

function TModelEntidadePedido.GetPedidos: TListaPedidos;
var
   APedido: TPedido;
   AMunicipioModel: IModelEntidade;
begin
   Result := TListaPedidos.Create;
   Open();
   with fQuery do
      if not Query.IsEmpty then
         begin
            Query.First;
            AMunicipioModel := TModelEntidadesFactory.New(fTipoConexao).Municipio;
            while not Query.Eof do
               begin
                  APedido := TPedido.Create;
                  APedido.Id := Query.FieldByName('id').AsInteger;
                  APedido.Endereco.Cep := Query.FieldByName('endereco_cep').AsString;
                  APedido.Endereco.Rua := Query.FieldByName('endereco_rua').AsString;
                  APedido.Endereco.Numero := Query.FieldByName('endereco_numero').AsString;
                  APedido.Endereco.Bairro := Query.FieldByName('endereco_bairro').AsString;
                  APedido.Endereco.Municipio := TModelEntidadeMunicipio(AMunicipioModel).GetMunicipio(Query.FieldByName('endereco_municipio_id').AsInteger);
                  if Query.FieldByName('situacao').AsInteger = 1 then
                     APedido.Situacao := 'Elaboração'
                  else if Query.FieldByName('situacao').AsInteger = 2 then
                          APedido.Situacao := 'Entrega Pendente'
                  else if Query.FieldByName('situacao').AsInteger = 3 then
                          APedido.Situacao := 'Entregue';
                  Result.Add(APedido);
                  Query.Next;
               end;
         end;
end;

class function TModelEntidadePedido.New(const ATipoConexao: TTipoConexao = tcFireDAC): IModelEntidade;
begin
   Result := Self.Create(ATipoConexao);
end;

procedure TModelEntidadePedido.Open(const AWhere: String);
var
   ASQL: String;
begin
   ASQL := '';
   ASQL := ASQL + 'SELECT id, nome_cliente, endereco_cep, endereco_rua, ';
   ASQL := ASQL + 'endereco_numero, endereco_bairro, endereco_municipio_id, ';
   ASQL := ASQL + 'situacao ';
   ASQL := ASQL + 'FROM pedidos';
   if AWhere <> '' then
      ASQL := ASQL + ' ' + AWhere;
   fQuery.Open(ASQL);
   // Definindo o campo id, como autoincremento
   fQuery.Query.FieldByName('id').AutoGenerateValue := TAutoRefreshFlag.arAutoInc;
   fQuery.Query.FieldByName('id').Required := False;
end;

end.
