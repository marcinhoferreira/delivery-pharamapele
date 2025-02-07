unit MiniDelivery.Entidades.Interfaces;

interface

uses
  Data.DB;

type
   IModelEntidade = interface
      ['{BE1C1D2D-891E-430C-B177-3311322C7046}']
      function DataSet(const Value: TDataSource): IModelEntidade; overload;
      function DataSet(const Value: TDataSet): IModelEntidade; overload;
      procedure Open(const AWhere: String = '');
   end;

   IModelEntidadeFactory = interface
      ['{8ECAABC4-9FC2-4A60-8C4C-444E898F67C8}']
      function TipoProduto: IModelEntidade;
      function Produto: IModelEntidade;
      function UnidadeMedida: IModelEntidade;
      function Pais: IModelEntidade;
      function Estado: IModelEntidade;
      function Municipio: IModelEntidade;
      function Pedido: IModelEntidade;
      function ItemPedido: IModelEntidade;
      function Entregador: IModelEntidade;
   end;

implementation

end.
