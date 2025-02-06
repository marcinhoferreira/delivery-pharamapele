unit MiniDelivery.Model.Entidades.Factory;

interface

uses
  SysUtils, Classes,
  MiniDelivery.Conexao.Interfaces,
  MiniDelivery.Entidades.Interfaces;

type
   TModelEntidadesFactory = class(TInterfacedObject, IModelEntidadeFactory)
   private
      { Private declarations }
      fTipoConexao: TTipoConexao;
      fTipoProduto: IModelEntidade;
      fProduto: IModelEntidade;
      fUnidadeMedida: IModelEntidade;
      fPais: IModelEntidade;
      fEstado: IModelEntidade;
      fMunicipio: IModelEntidade;
      fPedido: IModelEntidade;
      fItemPedido: IModelEntidade;
   public
      { Public declarations }
      constructor Create(const ATipoConexao: TTipoConexao = tcFireDAC);
      destructor Destroy; override;
      class function New(const ATipoConexao: TTipoConexao = tcFireDAC): IModelEntidadeFactory;
      function TipoProduto: IModelEntidade;
      function Produto: IModelEntidade;
      function UnidadeMedida: IModelEntidade;
      function Pais: IModelEntidade;
      function Estado: IModelEntidade;
      function Municipio: IModelEntidade;
      function Pedido: IModelEntidade;
      function ItemPedido: IModelEntidade;
    end;

implementation

uses
   MiniDelivery.Model.Entidades.Produto,
   MiniDelivery.Model.Entidades.UnidadeMedida,
   MiniDelivery.Model.Entidades.Pais,
   MiniDelivery.Model.Entidades.Estado,
   MiniDelivery.Model.Entidades.Municipio,
   MiniDelivery.Model.Entidades.ItemPedido,
   MiniDelivery.Model.Entidades.Pedido;

{ TModelEntidadesFactory }

destructor TModelEntidadesFactory.Destroy;
begin

   inherited;
end;

function TModelEntidadesFactory.Estado: IModelEntidade;
begin
   if not Assigned(fEstado) then
      fEstado := TModelEntidadeEstado.New(fTipoConexao);
   Result := fEstado;
end;

function TModelEntidadesFactory.ItemPedido: IModelEntidade;
begin
   if not Assigned(fItemPedido) then
      fItemPedido := TModelEntidadeItemPedido.New(fTipoConexao);
   Result := fItemPedido;
end;

function TModelEntidadesFactory.Municipio: IModelEntidade;
begin
   if not Assigned(fMunicipio) then
      fMunicipio := TModelEntidadeMunicipio.New(fTipoConexao);
   Result := fMunicipio;
end;

function TModelEntidadesFactory.Pais: IModelEntidade;
begin
   if not Assigned(fPais) then
      fPais := TModelEntidadePais.New(fTipoConexao);
   Result := fPais;
end;

function TModelEntidadesFactory.Produto: IModelEntidade;
begin
   if not Assigned(fProduto) then
      fProduto := TModelEntidadeProduto.New(fTipoConexao);
   Result := fProduto;
end;

function TModelEntidadesFactory.TipoProduto: IModelEntidade;
begin
   if not Assigned(fTipoProduto) then
      fTipoProduto := TModelEntidadeTipoProduto.New(fTipoConexao);
   Result := fTipoProduto;
end;

function TModelEntidadesFactory.UnidadeMedida: IModelEntidade;
begin
   if not Assigned(fUnidadeMedida) then
      fUnidadeMedida := TModelEntidadeUnidadeMedida.New(fTipoConexao);
   Result := fUnidadeMedida;
end;

function TModelEntidadesFactory.Pedido: IModelEntidade;
begin
   if not Assigned(fPedido) then
      fPedido := TModelEntidadePedido.New(fTipoConexao);
   Result := fPedido;
end;

class function TModelEntidadesFactory.New(const ATipoConexao: TTipoConexao = tcFireDAC): IModelEntidadeFactory;
begin
   Result := Self.Create(ATipoConexao);
end;

constructor TModelEntidadesFactory.Create(const ATipoConexao: TTipoConexao = tcFireDAC);
begin
   fTipoConexao := ATipoConexao;
end;

end.
