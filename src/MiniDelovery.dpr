program MiniDelovery;

uses
  System.StartUpCopy,
  FMX.Forms,
  MiniDelivery.Classe.UnidadeMedida in 'Classes\MiniDelivery.Classe.UnidadeMedida.pas',
  MiniDelivery.Classe.Produto in 'Classes\MiniDelivery.Classe.Produto.pas',
  MiniDelivery.Classe.Endereco in 'Classes\MiniDelivery.Classe.Endereco.pas',
  MiniDelivery.Classe.Pedido in 'Classes\MiniDelivery.Classe.Pedido.pas',
  FMX.MultiView.CustomPresentation in 'Libraries\FMX.MultiView.CustomPresentation.pas',
  MiniDelivery.Conexao.Interfaces in 'Interfaces\MiniDelivery.Conexao.Interfaces.pas',
  MiniDelivery.Model.Conexao.FireDAC.Conexao in 'Models\MiniDelivery.Model.Conexao.FireDAC.Conexao.pas',
  MiniDelivery.Model.Conexao.FireDAC.Query in 'Models\MiniDelivery.Model.Conexao.FireDAC.Query.pas',
  MiniDelivery.Model.Conexao.FireDAC.StoredProc in 'Models\MiniDelivery.Model.Conexao.FireDAC.StoredProc.pas',
  MiniDelivery.Model.Conexao.Factory in 'Models\MiniDelivery.Model.Conexao.Factory.pas',
  MiniDelivery.Entidades.Interfaces in 'Interfaces\MiniDelivery.Entidades.Interfaces.pas',
  MiniDelivery.Model.Entidades.UnidadeMedida in 'Models\MiniDelivery.Model.Entidades.UnidadeMedida.pas',
  MiniDelivery.Model.Entidades.Produto in 'Models\MiniDelivery.Model.Entidades.Produto.pas',
  MiniDelivery.Model.Entidades.Pais in 'Models\MiniDelivery.Model.Entidades.Pais.pas',
  MiniDelivery.Model.Entidades.Estado in 'Models\MiniDelivery.Model.Entidades.Estado.pas',
  MiniDelivery.Model.Entidades.Municipio in 'Models\MiniDelivery.Model.Entidades.Municipio.pas',
  MiniDelivery.Model.Entidades.Pedido in 'Models\MiniDelivery.Model.Entidades.Pedido.pas',
  MiniDelivery.Model.Entidades.Factory in 'Models\MiniDelivery.Model.Entidades.Factory.pas',
  MiniDelivery.View.MenuPrincipal in 'Views\MiniDelivery.View.MenuPrincipal.pas' {frmMenuPrincipal},
  MiniDelivery.View.Padrao in 'Views\MiniDelivery.View.Padrao.pas' {frmPadrao},
  MiniDelivery.View.CriarPedido in 'Views\MiniDelivery.View.CriarPedido.pas' {frmCriarPedido},
  MiniDelivery.View.CriarOrdemEntrega in 'Views\MiniDelivery.View.CriarOrdemEntrega.pas' {frmCriarOrdemEntrega},
  MiniDelivery.View.AcompanharEntrega in 'Views\MiniDelivery.View.AcompanharEntrega.pas' {frmAcompanharEntrega},
  MiniDelivery.Controller.Interfaces in 'Interfaces\MiniDelivery.Controller.Interfaces.pas',
  MiniDelivery.Controller in 'Controllers\MiniDelivery.Controller.pas',
  MiniDelivery.Model.Entidades.ItemPedido in 'Models\MiniDelivery.Model.Entidades.ItemPedido.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Mini Delivery Pharmapele';
  Application.CreateForm(TfrmMenuPrincipal, frmMenuPrincipal);
  Application.Run;
end.
