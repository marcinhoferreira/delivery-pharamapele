unit MiniDelivery.Controller.Interfaces;

interface

uses
   MiniDelivery.Entidades.Interfaces;

type
   IController = interface
      ['{25D5A6E9-DC2C-463E-95CE-36F5C7468869}']
      function Entidades: IModelEntidadeFactory;
   end;

   IWebServiceController = interface
      ['{3A00C441-C221-44F5-B008-98C18F05325B}']
   end;

implementation

end.
