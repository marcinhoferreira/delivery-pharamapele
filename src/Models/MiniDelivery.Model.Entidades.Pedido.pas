unit MiniDelivery.Model.Entidades.Pedido;

interface

uses
   SysUtils, Data.DB,
   MiniDelivery.Conexao.Interfaces,
   MiniDelivery.Entidades.Interfaces,
   MiniDelivery.Classe.Produto,
   MiniDelivery.Classe.Pedido,
   MiniDelivery.Classe.Entregador;

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
      function GetPedidoDigitacao: TPedido;
      function GetPedido(const Id: Integer): TPedido;
      function GetPedidos: TListaPedidos; overload;
      function GetPedidos(const Status: TStatus): TListaPedidos; overload;
      function GetPedidosEntrega: TListaPedidos; overload;
      function CriaPedido: TPedido;
      procedure AtribuiEntregador(const Id: Integer; const Entregador: TEntregador);
      procedure GravaPedido(const Pedido: TPedido);
      procedure FinalizaPedido(const Pedido: TPedido);
   end;


implementation

uses
   MiniDelivery.Model.Conexao.Factory,
   MiniDelivery.Model.Entidades.Factory,
   MiniDelivery.Model.Entidades.Produto,
   MiniDelivery.Model.Entidades.Municipio,
   MiniDelivery.Model.Entidades.ItemPedido,
   MiniDelivery.Model.Entidades.Entregador;

procedure StatusGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
   if Sender.AsInteger = 1 then
      Text := 'Em digitação'
   else if Sender.AsInteger = 2 then
           Text := 'Finalizado';
   DisplayText := Text <> '';
end;

{ TModelEntidadePedido }

procedure TModelEntidadePedido.AtribuiEntregador(const Id: Integer;
  const Entregador: TEntregador);
begin
   Open(Format('WHERE id = %d', [Id]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            Query.Edit;
            Query.FieldByName('entregador_id').AsInteger := Entregador.Id;
            Query.FieldByName('status_entrega').AsInteger := 1;
            Query.Post;
         end;
end;

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
               // Status : 1 - Em digitação, 2 - Finalizado
               Query.FieldByName('status').AsInteger := 1;
               // Status Entrega: 1 - Pendente, 2 - Em andamento, 3 - Entregue
               Query.FieldByName('status_entrega').AsInteger := 1;
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
            Query.FieldByName('nome_cliente').AsString := Pedido.Nome;
            Query.FieldByName('endereco_cep').AsString := Pedido.Endereco.Cep;
            Query.FieldByName('endereco_rua').AsString := Pedido.Endereco.Rua;
            Query.FieldByName('endereco_numero').AsString := Pedido.Endereco.Numero;
            Query.FieldByName('endereco_bairro').AsString := Pedido.Endereco.Bairro;
            Query.FieldByName('endereco_municipio_id').AsInteger := Pedido.Endereco.Municipio.Id;
            // Status : 1 - Em digitação, 2 - Finalizado
            Query.FieldByName('status').AsInteger := 2;
            Query.Post;
         end;
end;

function TModelEntidadePedido.GetPedido(const Id: Integer): TPedido;
var
   AMunicipioModel,
   AEntregadorModel: IModelEntidade;
begin
   Result := TPedido.Create;
   Open(Format('WHERE id = %d', [Id]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            AMunicipioModel := TModelEntidadesFactory.New(fTipoConexao).Municipio;
            AEntregadorModel := TModelEntidadesFactory.New(fTipoConexao).Entregador;
            Result.Id := Query.FieldByName('id').AsInteger;
            Result.Nome := Query.FieldByName('nome_cliente').AsString;
            Result.Endereco.Cep := Query.FieldByName('endereco_cep').AsString;
            Result.Endereco.Rua := Query.FieldByName('endereco_rua').AsString;
            Result.Endereco.Numero := Query.FieldByName('endereco_numero').AsString;
            Result.Endereco.Bairro := Query.FieldByName('endereco_bairro').AsString;
            Result.Endereco.Municipio := TModelEntidadeMunicipio(AMunicipioModel).GetMunicipio(Query.FieldByName('endereco_municipio_id').AsInteger);
            if Query.FieldByName('status').AsInteger = 1 then
               Result.Status := TStatus.stDigitacao
            else if Query.FieldByName('status').AsInteger = 2 then
                    Result.Status := TStatus.stFinalizado;
            Result.Entregador := TModelEntidadeEntregador(AEntregadorModel).GetEntregador(Query.FieldByName('entregador_id').AsInteger);
            if Query.FieldByName('status_entrega').AsInteger = 1 then
               Result.StatusEntrega := TStatusEntrega.sePendente
            else if Query.FieldByName('status_entrega').AsInteger = 2 then
                    Result.StatusEntrega := TStatusEntrega.seEmAndamento
            else if Query.FieldByName('status_entrega').AsInteger = 3 then
                    Result.StatusEntrega := TStatusEntrega.seEntregue;
         end;
end;

function TModelEntidadePedido.GetPedidoDigitacao: TPedido;
begin
   Result := TPedido.Create;
   Open('WHERE status = 1');
   with fQuery do
      begin
         if Query.IsEmpty then
            Result := CriaPedido
         else
            Result := GetPedido(Query.FieldByName('id').AsInteger);
      end;
end;

function TModelEntidadePedido.GetPedidosEntrega: TListaPedidos;
var
   APedido: TPedido;
   AMunicipioModel,
   AEntregadorModel: IModelEntidade;
begin
   Result := TListaPedidos.Create;
   Open('WHERE status = 2');
   with fQuery do
      if not Query.IsEmpty then
         begin
            Query.First;
            AMunicipioModel := TModelEntidadesFactory.New(fTipoConexao).Municipio;
            AEntregadorModel := TModelEntidadesFactory.New(fTipoConexao).Entregador;
            while not Query.Eof do
               begin
                  APedido := TPedido.Create;
                  APedido.Id := Query.FieldByName('id').AsInteger;
                  APedido.Nome := Query.FieldByName('nome_cliente').AsString;
                  APedido.Endereco.Cep := Query.FieldByName('endereco_cep').AsString;
                  APedido.Endereco.Rua := Query.FieldByName('endereco_rua').AsString;
                  APedido.Endereco.Numero := Query.FieldByName('endereco_numero').AsString;
                  APedido.Endereco.Bairro := Query.FieldByName('endereco_bairro').AsString;
                  APedido.Endereco.Municipio := TModelEntidadeMunicipio(AMunicipioModel).GetMunicipio(Query.FieldByName('endereco_municipio_id').AsInteger);
                  if Query.FieldByName('status').AsInteger = 1 then
                     APedido.Status := TStatus.stDigitacao
                  else if Query.FieldByName('status').AsInteger = 2 then
                          APedido.Status := TStatus.stFinalizado;
                  APedido.Entregador := TModelEntidadeEntregador(AEntregadorModel).GetEntregador(Query.FieldByName('entregador_id').AsInteger);
                  if Query.FieldByName('status_entrega').AsInteger = 1 then
                     APedido.StatusEntrega := TStatusEntrega.sePendente
                  else if Query.FieldByName('status_entrega').AsInteger = 2 then
                          APedido.StatusEntrega := TStatusEntrega.seEmAndamento
                  else if Query.FieldByName('status_entrega').AsInteger = 3 then
                          APedido.StatusEntrega := TStatusEntrega.seEntregue;
                  Result.Add(APedido);
                  Query.Next;
               end;
         end;
end;

procedure TModelEntidadePedido.GravaPedido(const Pedido: TPedido);
begin
   Open(Format('WHERE id = %d', [Pedido.Id]));
   with fQuery do
      if not Query.IsEmpty then
         begin
            Query.Edit;
            Query.FieldByName('nome_cliente').AsString := Pedido.Nome;
            Query.FieldByName('endereco_cep').AsString := Pedido.Endereco.Cep;
            Query.FieldByName('endereco_rua').AsString := Pedido.Endereco.Rua;
            Query.FieldByName('endereco_numero').AsString := Pedido.Endereco.Numero;
            Query.FieldByName('endereco_bairro').AsString := Pedido.Endereco.Bairro;
            Query.FieldByName('endereco_municipio_id').AsInteger := Pedido.Endereco.Municipio.Id;
            Query.FieldByName('entregador_id').AsInteger := Pedido.Entregador.Id;
            // Status : 1 - Em digitação, 2 - Finalizado
            if Pedido.Status = TStatus.stDigitacao then
               Query.FieldByName('status').AsInteger := 1
            else if Pedido.Status = TStatus.stFinalizado then
                    Query.FieldByName('status').AsInteger := 2;
            // Status da Entrega : 1 - Pendente, 2 - Em andamento, 3 - Entregue;
            if Pedido.StatusEntrega = TStatusEntrega.sePendente then
               Query.FieldByName('status_entrega').AsInteger := 1
            else if Pedido.StatusEntrega = TStatusEntrega.seEmAndamento then
                    Query.FieldByName('status_entrega').AsInteger := 2
            else if Pedido.StatusEntrega = TStatusEntrega.seEntregue then
                    Query.FieldByName('status_entrega').AsInteger := 3;
            Query.Post;
         end;
end;

function TModelEntidadePedido.GetPedidos: TListaPedidos;
var
   APedido: TPedido;
   AMunicipioModel,
   AEntregadorModel: IModelEntidade;
begin
   Result := TListaPedidos.Create;
   Open();
   with fQuery do
      if not Query.IsEmpty then
         begin
            Query.First;
            AMunicipioModel := TModelEntidadesFactory.New(fTipoConexao).Municipio;
            AEntregadorModel := TModelEntidadesFactory.New(fTipoConexao).Entregador;
            while not Query.Eof do
               begin
                  APedido := TPedido.Create;
                  APedido.Id := Query.FieldByName('id').AsInteger;
                  APedido.Nome := Query.FieldByName('nome_cliente').AsString;
                  APedido.Endereco.Cep := Query.FieldByName('endereco_cep').AsString;
                  APedido.Endereco.Rua := Query.FieldByName('endereco_rua').AsString;
                  APedido.Endereco.Numero := Query.FieldByName('endereco_numero').AsString;
                  APedido.Endereco.Bairro := Query.FieldByName('endereco_bairro').AsString;
                  APedido.Endereco.Municipio := TModelEntidadeMunicipio(AMunicipioModel).GetMunicipio(Query.FieldByName('endereco_municipio_id').AsInteger);
                  if Query.FieldByName('status').AsInteger = 1 then
                     APedido.Status := TStatus.stDigitacao
                  else if Query.FieldByName('status').AsInteger = 2 then
                          APedido.Status := TStatus.stFinalizado;
                  APedido.Entregador := TModelEntidadeEntregador(AEntregadorModel).GetEntregador(Query.FieldByName('entregador_id').AsInteger);
                  if Query.FieldByName('status_entrega').AsInteger = 1 then
                     APedido.StatusEntrega := TStatusEntrega.sePendente
                  else if Query.FieldByName('status_entrega').AsInteger = 2 then
                          APedido.StatusEntrega := TStatusEntrega.seEmAndamento
                  else if Query.FieldByName('status_entrega').AsInteger = 3 then
                          APedido.StatusEntrega := TStatusEntrega.seEntregue;
                  Result.Add(APedido);
                  Query.Next;
               end;
         end;
end;

function TModelEntidadePedido.GetPedidos(const Status: TStatus): TListaPedidos;
var
   APedido: TPedido;
   AMunicipioModel,
   AEntregadorModel: IModelEntidade;
begin
   Result := TListaPedidos.Create;
   if Status = TStatus.stDigitacao then
      Open('WHERE status = 1')
   else if Status = TStatus.stFinalizado then
           Open('WHERE status = 2');
   with fQuery do
      if not Query.IsEmpty then
         begin
            Query.First;
            AMunicipioModel := TModelEntidadesFactory.New(fTipoConexao).Municipio;
            AEntregadorModel := TModelEntidadesFactory.New(fTipoConexao).Entregador;
            while not Query.Eof do
               begin
                  APedido := TPedido.Create;
                  APedido.Id := Query.FieldByName('id').AsInteger;
                  APedido.Nome := Query.FieldByName('nome_cliente').AsString;
                  APedido.Endereco.Cep := Query.FieldByName('endereco_cep').AsString;
                  APedido.Endereco.Rua := Query.FieldByName('endereco_rua').AsString;
                  APedido.Endereco.Numero := Query.FieldByName('endereco_numero').AsString;
                  APedido.Endereco.Bairro := Query.FieldByName('endereco_bairro').AsString;
                  APedido.Endereco.Municipio := TModelEntidadeMunicipio(AMunicipioModel).GetMunicipio(Query.FieldByName('endereco_municipio_id').AsInteger);
                  if Query.FieldByName('status').AsInteger = 1 then
                     APedido.Status := TStatus.stDigitacao
                  else if Query.FieldByName('status').AsInteger = 2 then
                          APedido.Status := TStatus.stFinalizado;
                  APedido.Entregador := TModelEntidadeEntregador(AEntregadorModel).GetEntregador(Query.FieldByName('entregador_id').AsInteger);
                  if Query.FieldByName('status_entrega').AsInteger = 1 then
                     APedido.StatusEntrega := TStatusEntrega.sePendente
                  else if Query.FieldByName('status_entrega').AsInteger = 2 then
                          APedido.StatusEntrega := TStatusEntrega.seEmAndamento
                  else if Query.FieldByName('status_entrega').AsInteger = 3 then
                          APedido.StatusEntrega := TStatusEntrega.seEntregue;
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
   ASQL := ASQL + 'status, entregador_id, status_entrega ';
   ASQL := ASQL + 'FROM pedidos';
   if AWhere <> '' then
      ASQL := ASQL + ' ' + AWhere;
   fQuery.Open(ASQL);
   // Definindo o campo id, como autoincremento
   with fQuery do
      begin
         Query.FieldByName('id').AutoGenerateValue := TAutoRefreshFlag.arAutoInc;
         Query.FieldByName('id').Required := False;
      end;
end;

end.
