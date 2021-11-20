program ExemploCadastro;

uses
  Vcl.Forms,
  uExemplo_Cadastro in 'uExemplo_Cadastro.pas' {FrmCadastro},
  uCadastro_model in 'model\uCadastro_model.pas',
  uCadastro_controller in 'controller\uCadastro_controller.pas',
  uFrmConfig in 'view\uFrmConfig.pas' {FrmConfig},
  uFrmAviso in 'view\uFrmAviso.pas' {FrmAviso};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmCadastro, FrmCadastro);
  Application.CreateForm(TFrmConfig, FrmConfig);
  Application.CreateForm(TFrmAviso, FrmAviso);
  Application.Run;
end.
