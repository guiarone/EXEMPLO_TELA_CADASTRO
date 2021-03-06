unit uExemplo_Cadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ComCtrls, Vcl.Mask, IPPeerClient, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, System.JSON, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,
  uCadastro_controller, uCadastro_model;

type
  TFrmCadastro = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btSalvar: TBitBtn;
    btExcluir: TBitBtn;
    btConfig: TBitBtn;
    Label1: TLabel;
    edID: TEdit;
    lvCadastro: TListView;
    Label2: TLabel;
    edNome: TEdit;
    Label3: TLabel;
    edIdentidade: TEdit;
    Label4: TLabel;
    edCPF: TMaskEdit;
    Label5: TLabel;
    edTelefone: TEdit;
    Label6: TLabel;
    edEmail: TEdit;
    Label7: TLabel;
    edCep: TMaskEdit;
    Label8: TLabel;
    edLogradouro: TEdit;
    Label9: TLabel;
    edNumero: TEdit;
    Label10: TLabel;
    edComplemento: TEdit;
    Label11: TLabel;
    edBairro: TEdit;
    Label12: TLabel;
    edCidade: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    edPais: TEdit;
    btNovo: TBitBtn;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTClient1: TRESTClient;
    XMLDocument1: TXMLDocument;
    btListar: TBitBtn;
    cboxEstado: TComboBox;
    brFechar: TBitBtn;
    btEnviar: TBitBtn;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure LimpaCampos;
    procedure btNovoClick(Sender: TObject);
    procedure edCepExit(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btListarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lvCadastroClick(Sender: TObject);
    procedure btAlterarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btConfigClick(Sender: TObject);
    procedure brFecharClick(Sender: TObject);
    procedure btEnviarClick(Sender: TObject);
  private
    { Private declarations }
    Fcontroller: TCadastro_Controller;
    procedure BuscaCEP;
    procedure Consultar;
    procedure EncheLista;
  public
    { Public declarations }
  end;

var
  FrmCadastro: TFrmCadastro;

implementation

{$R *.dfm}

uses uFrmConfig, uFrmAviso;
function isEmail(oEmail: string): boolean;
  function CheckAllowed(s: string): boolean;
  var
    i: Integer;
  begin
    result:= False;
    for i:= 1 to Length(s) do
      if not(s[i] in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', '_', '-', '.']) then
        exit;
    result := true;
  end;
var
  i: Integer;
  namePart, serverPart: string;
begin
  Result:= False;
  i:= Pos('@', oEmail);
  if i = 0 then
    exit;
  namePart:= Copy(oEmail, 1, i - 1);
  serverPart:= Copy(oEmail, i + 1, Length(oEmail));
  if (Length(namePart) = 0) or ((Length(serverPart) < 5)) then
    exit;
  i:= Pos('.', serverPart);
  if (i = 0) or (i > (Length(ServerPart) - 2)) then
    exit;
  result:= CheckAllowed(namePart) and CheckAllowed(serverPart);
end;

function isCPF(oCpf: string): boolean;
var  dig10, dig11: string;
    s, i, r, peso: integer;
begin
//retorna o tamanho da string (oCpf ? um n?mero formado por 11 d?gitos)
  if ((oCpf = '00000000000') or (oCpf = '11111111111') or
      (oCpf = '22222222222') or (oCpf = '33333333333') or
      (oCpf = '44444444444') or (oCpf = '55555555555') or
      (oCpf = '66666666666') or (oCpf = '77777777777') or
      (oCpf = '88888888888') or (oCpf = '99999999999') or
      (length(oCpf) <> 11)) then
  begin
    isCPF:= false;
    exit;
  end;
  try
//1o. Digito Verificador
    s:= 0;
    peso:= 10;
    for i:= 1 to 9 do
    begin
//converte o i-?simo caractere do oCpf em um n?mero
      s:= s + (StrToInt(oCpf[i]) * peso);
      peso:= peso - 1;
    end;
    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11)) then
      dig10 := '0'
    else
      str(r:1, dig10); //converte um n?mero no respectivo caractere num?rico

//2o. Digito Verificador
    s:= 0;
    peso:= 11;
    for i:= 1 to 10 do
    begin
      s:= s + (StrToInt(oCpf[i]) * peso);
      peso:= peso - 1;
    end;
    r:= 11 - (s mod 11);
    if ((r = 10) or (r = 11))then
      dig11:= '0'
    else
      str(r:1, dig11);
// Verifica se os digitos calculados conferem com os digitos informados
    if ((dig10 = oCpf[10]) and (dig11 = oCpf[11])) then
      isCPF:= true
    else
      isCPF:= false;
  except
    isCPF:= false
  end;
end;

procedure TFrmCadastro.brFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFrmCadastro.btAlterarClick(Sender: TObject);
begin
  if lvCadastro.ItemIndex > -1 then
  begin
  end;
end;

procedure TFrmCadastro.btSalvarClick(Sender: TObject);
var
  cadastro: TCadastro;
  erro: string;
  msg, enviaremail: boolean;
begin
  enviaremail:= false;
  //testa nome valido
  if length(edNome.Text) < 5 then
  begin
    ShowMessage('Digite um nome v?lido');
    edNome.SetFocus;
    exit;
  end;
  //testa cpf valido
  msg:= false;
  if length(edCPF.Text) = 11 then
  begin
    if not isCPF(edCPF.Text) then
      msg:= true;
  end
  else
    if length(edCPF.Text) > 0 then
      msg:= true;
  if msg then
  begin
    ShowMessage('Digite um CPF v?lido, ou deixe em branco.');
    edCPF.Text:= '';
    edCPF.SetFocus;
    exit;
  end;
  //testa email valido
  if not isEmail(edEmail.Text) then
  begin
    ShowMessage('Digite um Email v?lido.');
    edEmail.SetFocus;
    exit;
  end;
  //verifica se ? novo ou altera??o
  if lvCadastro.ItemIndex < 0 then
    cadastro:= TCadastro.Create
  else
    Fcontroller.Consultar(strtoint(edID.Text), cadastro, erro);
  //atribui camos a classe modelo
  cadastro.Nome:= edNome.Text;
  cadastro.Identidade:= edIdentidade.Text;
  cadastro.CPF:= edCPF.Text;
  cadastro.Telefone:= edTelefone.Text;
  cadastro.Email:= edEmail.Text;
  cadastro.Cep:= edCep.Text;
  cadastro.Logradouro:= edLogradouro.Text;
  cadastro.Numero:= edNumero.Text;
  cadastro.Complemento:= edComplemento.Text;
  cadastro.Bairro:= edBairro.Text;
  cadastro.Cidade:= edCidade.Text;
  cadastro.Estado:= cboxEstado.Items[cboxEstado.ItemIndex];
  cadastro.Pais:= edPais.Text;
  //verifica se ? novo ou altera??o
  if lvCadastro.ItemIndex < 0 then
  begin
    if not Fcontroller.Incluir(cadastro, erro) then
      ShowMessage(erro)
    else
    begin
      ShowMessage('Incluido com sucesso!');
      enviaremail:= true;
    end;
  end
  else
  begin
    if not Fcontroller.Alterar(cadastro, erro) then
      ShowMessage(erro)
    else
    begin
      ShowMessage('Alterado com sucesso!');
      enviaremail:= true;
    end;
  end;
  if enviaremail then
    if MessageDlg('Opera??o realizada com sucesso. Deseja Enviar email?',
                  mtConfirmation, [mbYes, mbNo], 0) =
       mrYes then//confirma e exclui
    begin
      FrmAviso.Show;
      Application.ProcessMessages;
      FrmConfig.Enviar(cadastro);
      FrmAviso.Hide;
    end;
end;

procedure TFrmCadastro.btConfigClick(Sender: TObject);
begin
  FrmConfig.ShowModal;
end;

procedure TFrmCadastro.btEnviarClick(Sender: TObject);
var
  cadastro: TCadastro;
  erro: string;
begin
  if lvCadastro.ItemIndex > -1 then
  begin
    Fcontroller.Consultar(strtoint(edID.Text), cadastro, erro);
    FrmAviso.Show;
    Application.ProcessMessages;
    FrmConfig.Enviar(cadastro);
    FrmAviso.Hide;
  end
  else
    ShowMessage('Selecione um registro para enviar.')
end;

procedure TFrmCadastro.btExcluirClick(Sender: TObject);
var
  erro: string;
begin
  //verifica se tem registro selecionado
  if lvCadastro.ItemIndex > -1 then
  begin
    if MessageDlg('Confirma exclus?o?',mtConfirmation, [mbYes, mbNo], 0) =
       mrYes then//confirma e exclui
      if Fcontroller.Excluir(strtoint(edID.Text), erro) then
      begin
        ShowMessage('Excluido com sucesso!');
        LimpaCampos;
      end
      else//algo deu errado
        ShowMessage(erro);
  end;
end;

procedure TFrmCadastro.btListarClick(Sender: TObject);
begin
  //lista registros na listview
  EncheLista;
end;

procedure TFrmCadastro.btNovoClick(Sender: TObject);
begin
  //prepara interface para inclus?o
  LimpaCampos;
  lvCadastro.ItemIndex:= -1;
  edNome.SetFocus;
end;

procedure TFrmCadastro.BuscaCEP;
var
  jObj: TJSONObject;
  txt: string;
begin
//Busca os dados do endere?o em viaCEP
  Cursor:= crHourGlass;
  try
    RESTRequest1.Resource:= edCep.Text+'/json';
    RESTRequest1.Execute;
    txt:= '';
    RESTResponse1.GetSimpleValue('erro', txt);
    //se n?o retornou erro preenche os campos
    if txt = ''then
    begin
      RESTResponse1.GetSimpleValue('logradouro', txt);
      edLogradouro.Text:= txt;
      RESTResponse1.GetSimpleValue('complemento', txt);
      edComplemento.Text:= txt;
      RESTResponse1.GetSimpleValue('bairro', txt);
      edBairro.Text:= txt;
      RESTResponse1.GetSimpleValue('localidade', txt);
      edCidade.Text:= txt;
      RESTResponse1.GetSimpleValue('uf', txt);
      cboxEstado.ItemIndex:= cboxEstado.Items.IndexOf(txt);
      RESTResponse1.GetSimpleValue('ddd', txt);
      if edTelefone.Text = '' then
        edTelefone.Text:= txt;
      edNumero.SetFocus;
    end
    else
    begin
      showmessage('CEP n?o encontrado.');
      edCep.Clear;
      edCep.SetFocus;
    end;
    Cursor:= crDefault;
  except//API inecess?vel
    showmessage('Erro. N?o foi possivel acessar a API.');
    Cursor:= crDefault;
  end;
end;

procedure TFrmCadastro.Consultar;
var
  cadastro: TCadastro;
  erro: string;
begin
  //preenche os campos do registro selecionado
  if Fcontroller.Consultar(strtoint(lvCadastro.Items[lvCadastro.ItemIndex].Caption),
                        cadastro, erro ) then
  begin
    edID.Text:= inttostr(cadastro.Id);
    edNome.Text:= cadastro.Nome;
    edIdentidade.Text:= cadastro.Identidade;
    edCPF.Text:= cadastro.CPF;
    edTelefone.Text:= cadastro.Telefone;
    edEmail.Text:= cadastro.Email;
    edCep.Text:=  cadastro.Cep;
    edLogradouro.Text:= cadastro.Logradouro;
    edNumero.Text:= cadastro.Numero;
    edComplemento.Text:= cadastro.Complemento;
    edBairro.Text:= cadastro.Bairro;
    edCidade.Text:= cadastro.Cidade;
    cboxEstado.ItemIndex:= cboxEstado.Items.IndexOf(cadastro.Estado);
    edPais.Text:= cadastro.Pais;
  end
  else
    ShowMessage(erro);
end;

procedure TFrmCadastro.edCepExit(Sender: TObject);
begin
  //consulta API para preencher os dados de endere?o
  if length(edCep.Text) = 8 then
    BuscaCEP
  else
  begin
    if length(edCep.Text) > 0 then
    begin
      ShowMessage('Digite um CEP v?lido.');
      edCEP.SetFocus;
    end;
  end;
end;

procedure TFrmCadastro.EncheLista;
var
  item: TListItem;
  i: Integer;
  cadastro: TCadastro;
  erro: string;
begin
  //visible false para n?o ficar lento
  lvCadastro.Visible:= false;
  //limpa
  lvCadastro.Clear;
  //enche listview com registros n?o excluidos
  for i:= 0 to pred(Fcontroller.Count) do
    if Fcontroller.ConsultaByIndice(i, cadastro, erro) > -1 then
    begin
      if not cadastro.Excluido then//testa flag para excluidos
      begin
        //enche campos da lv
        item:= lvCadastro.Items.Add;
        item.Caption:= inttostr(cadastro.Id);
        item.SubItems.Add(cadastro.Nome);
        item.SubItems.Add(cadastro.Identidade);
        item.SubItems.Add(cadastro.CPF);
        item.SubItems.Add(cadastro.Telefone);
        item.SubItems.Add(cadastro.Email);
        item.SubItems.Add(cadastro.Cep);
        item.SubItems.Add(cadastro.Logradouro);
        item.SubItems.Add(cadastro.Numero);
        item.SubItems.Add(cadastro.Complemento);
        item.SubItems.Add(cadastro.Bairro);
        item.SubItems.Add(cadastro.Cidade);
        item.SubItems.Add(cadastro.Estado);
        item.SubItems.Add(cadastro.Pais);
      end;
    end
    else//erro
      ShowMessage(erro);
  //
  lvCadastro.Visible:= true;
end;

procedure TFrmCadastro.FormCreate(Sender: TObject);
begin
  //cria classe controller
  Fcontroller:= TCadastro_Controller.Create;
end;

procedure TFrmCadastro.FormDestroy(Sender: TObject);
begin
  //finaliza classe controller
  Fcontroller.Free;
end;

procedure TFrmCadastro.FormKeyPress(Sender: TObject; var Key: Char);
begin
  //trocar enter por tab
  If key = #13 then
  begin
    Key:= #0;
    Perform(Wm_NextDlgCtl,0,0);
  end;
end;

procedure TFrmCadastro.FormShow(Sender: TObject);
begin
  btNovo.Click;
end;

procedure TFrmCadastro.LimpaCampos;
var
  i: Integer;
begin
  for i := 0 to FrmCadastro.ComponentCount -1 do
  begin
    if FrmCadastro.Components[i] is TEdit then
      TEdit(FrmCadastro.Components[i]).Clear;
    if FrmCadastro.Components[i] is TMaskEdit then
      TMaskEdit(FrmCadastro.Components[i]).Clear
  end;
end;

procedure TFrmCadastro.lvCadastroClick(Sender: TObject);
begin
  //se clicar na lv seleciona o registro
  if lvCadastro.ItemIndex > -1 then
    Consultar;
end;

end.
