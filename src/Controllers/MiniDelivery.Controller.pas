unit MiniDelivery.Controller;

interface

uses
  SysUtils, Classes,
  MiniDelivery.Controller.Interfaces,
  MiniDelivery.Entidades.Interfaces;

Type
   TController = class(TInterfacedObject, IController)
   private
      { Private declarations }
      fModelEntidades: IModelEntidadeFactory;
   public
      { Public declarations }
      constructor Create;
      destructor Destroy; override;
      class function New: IController;
      function Entidades: IModelEntidadeFactory;
   end;

implementation

uses
   MiniDelivery.Model.Entidades.Factory;

{ TController }

constructor TController.Create;
begin
   fModelEntidades := TModelEntidadesFactory.New;
end;

destructor TController.Destroy;
begin
  inherited;
end;

function TController.Entidades: IModelEntidadeFactory;
begin
   Result := fModelEntidades;
end;

class function TController.New: IController;
begin
   Result := Self.Create;
end;

end.
