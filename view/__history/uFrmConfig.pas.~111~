unit uFrmConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  IdSMTP, IdSSLOpenSSL, IdMessage, IdText, IdAttachmentFile,
  IdExplicitTLSClientServerBase, Vcl.StdCtrls, Vcl.Buttons, uCadastro_Model;

type
  TFrmConfig = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btFechar: TBitBtn;
    btSalvar: TBitBtn;
    Label1: TLabel;
    edHost: TEdit;
    Label2: TLabel;
    edUserName: TEdit;
    Label3: TLabel;
    edPassword: TEdit;
    Label4: TLabel;
    edSubject: TEdit;
    Label5: TLabel;
    edPort: TEdit;
    labelX: TLabel;
    procedure btSalvarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btFecharClick(Sender: TObject);
  private
    { Private declarations }
    function GerarXML(ocadastro: TCadastro): string;
  public
    { Public declarations }
    function Enviar(oCadastro: TCadastro): boolean;
  end;

var
  FrmConfig: TFrmConfig;

implementation

{$R *.dfm}
uses
  inifiles, XMLDoc, XMLIntf;

function Criptografar(const key, texto: String): String;
var
  I: Integer;
  C: Byte;
begin
  Result:= '';
  for I:= 1 to Length(texto) do
  begin
    if Length(Key) > 0 then
      C:= Byte(Key[1 + ((I - 1) mod Length(Key))]) xor Byte(texto[I])
    else
      C:= Byte(texto[I]);
    Result:= Result + AnsiLowerCase(IntToHex(C, 2));
  end;
end;

function Descriptografar(const key, texto: String): String;
var
  I: Integer;
  C: Char;
begin
  Result := '';
  for I := 0 to Length(texto) div 2 - 1 do begin
    C:= Chr(StrToIntDef('$' + Copy(texto, (I * 2) + 1, 2), Ord(' ')));
    if Length(Key) > 0 then
      C:= Chr(Byte(Key[1 + (I mod Length(Key))]) xor Byte(C));
    Result:= Result + C;
  end;
end;

procedure TFrmConfig.btFecharClick(Sender: TObject);
begin
  close;
end;

procedure TFrmConfig.btSalvarClick(Sender: TObject);
var
  Arquivo: TIniFile;
  senha: string;
begin
  Arquivo:= TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    Arquivo.WriteString('EMAIL', 'HOST', edHost.Text);
    Arquivo.WriteInteger('EMAIL', 'PORT', StrToInt(edPort.Text));
    Arquivo.WriteString('EMAIL', 'USER_NAME', edUserName.Text);
    Arquivo.WriteString('EMAIL', 'SUBJECT', edSubject.Text);
    Arquivo.WriteString('EMAIL', 'PASSWORD', Criptografar('7bb7k8', edPassword.Text));
  finally
    Arquivo.Free;
  end;
end;

function TFrmConfig.GerarXML(ocadastro: TCadastro): string;
var
  XMLDocument: TXMLDocument;
  NodeTabela, NodeRegistro, NodeEndereco: IXMLNode;
  I: Integer;
  nomearq: string;
begin
  XMLDocument := TXMLDocument.Create(Self);
  try
    XMLDocument.Active := True;
    NodeTabela := XMLDocument.AddChild('Dados_Cadastrais');
    NodeRegistro := NodeTabela.AddChild('Registro');
    NodeRegistro.ChildValues['Id'] := inttostr(oCadastro.Id);
    NodeRegistro.ChildValues['Nome'] := oCadastro.Nome;
    NodeRegistro.ChildValues['Identidade'] := oCadastro.Identidade;
    NodeRegistro.ChildValues['CPF'] := oCadastro.CPF;
    NodeRegistro.ChildValues['Telefone'] := oCadastro.Telefone;
    NodeRegistro.ChildValues['Email'] := oCadastro.Email;
    NodeEndereco:= NodeRegistro.AddChild('Endereco');
    NodeEndereco.ChildValues['Logradouro'] := oCadastro.Logradouro;
    NodeEndereco.ChildValues['Complemento']:= oCadastro.Complemento;
    NodeEndereco.ChildValues['Bairro']:= oCadastro.Bairro;
    NodeEndereco.ChildValues['Cidade']:= oCadastro.Cidade;
    NodeEndereco.ChildValues['Estado']:= oCadastro.Estado;
    NodeEndereco.ChildValues['CEP']:= oCadastro.Cep;
    NodeEndereco.ChildValues['Número']:= oCadastro.Numero;
    NodeEndereco.ChildValues['Pais']:= oCadastro.Pais;
    nomearq:= ChangeFileExt(Application.ExeName,'.xml');
    XMLDocument.SaveToFile(nomearq);
    result:= nomearq;
  finally
    XMLDocument.Free;
  end;
end;
function TFrmConfig.Enviar(oCadastro: TCadastro): boolean;
var
  IdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  IdText: TIdText;
  sAnexo: string;
  servidor: shortstring;
begin
  result:= false;
//cria objetos
  IdSSLIOHandlerSocket := TIdSSLIOHandlerSocketOpenSSL.Create(Self);
  IdSMTP:= TIdSMTP.Create(Self);
  IdMessage:= TIdMessage.Create(Self);
  try
//Configuração da mensagem
    IdMessage.From.Address:= edUserName.Text;
    IdMessage.From.Name:= edSubject.Text;
    IdMessage.ReplyTo.EMailAddresses:= IdMessage.From.Address;
    IdMessage.Recipients.Add.Text:= oCadastro.Email;
    IdMessage.Subject:= edSubject.Text;
    IdMessage.Encoding:= meMIME;
//Configuração do corpo do email (TIdText)
    IdText:= TIdText.Create(IdMessage.MessageParts);
    IdText.Body.Add('Dados Cadastrais');
    IdText.Body.Add('Id : '+inttostr(oCadastro.Id));
    IdText.Body.Add('Nome : '+oCadastro.Nome);
    IdText.Body.Add('Identidade : '+oCadastro.Identidade);
    IdText.Body.Add('CPF : '+oCadastro.CPF);
    IdText.Body.Add('Telefone : '+oCadastro.Telefone);
    IdText.Body.Add('Email : '+oCadastro.Email);
    IdText.Body.Add('Logradouro : '+oCadastro.Logradouro);
    IdText.Body.Add('Complemento : '+oCadastro.Complemento);
    IdText.Body.Add('Bairro : '+oCadastro.Bairro);
    IdText.Body.Add('Cidade : '+oCadastro.Cidade);
    IdText.Body.Add('Estado : '+oCadastro.Estado);
    IdText.Body.Add('CEP : '+oCadastro.Cep);
    IdText.Body.Add('Número : '+oCadastro.Numero);
    IdText.Body.Add('Pais : '+oCadastro.Pais);
    IdText.ContentType:= 'text/plain; charset=iso-8859-1';
//anexo
    sAnexo:= '';
    sAnexo:= GerarXML(oCadastro);
    if FileExists(sAnexo) then
      TIdAttachmentFile.Create(IdMessage.MessageParts, sAnexo);
//descobre servidor para configurar particularidades...
    if Pos('gmail', edHost.Text) > 0 then
      servidor:= 'gmail'
    else
      if Pos('office365', edHost.Text) > 0 then
        servidor:= 'office365'
      else
        servidor:= 'outros';
//Configuração do protocolo SSL
    if servidor <> 'office365' then
      IdSSLIOHandlerSocket.SSLOptions.Method := sslvSSLv23
    else
      IdSSLIOHandlerSocket.SSLOptions.Method := sslvTLSv1;
    IdSSLIOHandlerSocket.SSLOptions.Mode := sslmClient;
//Configuração do servidor SMTP (TIdSMTP)
    IdSMTP.IOHandler := IdSSLIOHandlerSocket;
    if servidor <> 'gmail' then
      IdSMTP.UseTLS := utUseExplicitTLS
    else
      IdSMTP.UseTLS := utUseImplicitTLS;
    IdSMTP.AuthType := satDefault;
    IdSMTP.Port := strtoint(edPort.Text);
    IdSMTP.Host := edHost.Text;
    IdSMTP.Username := edUserName.Text;
    IdSMTP.Password := edPassword.Text;
//conexão e autenticação
    try
      IdSMTP.Connect;
      IdSMTP.Authenticate;
    except
      on E:Exception do
      begin
        MessageDlg('Erro na conexão ou autenticação: ' +
          E.Message, mtWarning, [mbOK], 0);
        Exit;
      end;
    end;
//Envia mensagem
    try
      IdSMTP.Send(IdMessage);
       MessageDlg('Mensagem enviada com sucesso!', mtInformation, [mbOK], 0);
      result:= true;
    except
      On E:Exception do
      begin
        MessageDlg('Erro ao enviar a mensagem: ' +
          E.Message, mtWarning, [mbOK], 0);
      end;
    end;
  finally
//Desconecta do servidor
    IdSMTP.Disconnect;
//Liberação da DLL
    UnLoadOpenSSLLibrary;
//Liberação dos objetos da memória
    FreeAndNil(IdMessage);
    FreeAndNil(IdSSLIOHandlerSocket);
    FreeAndNil(IdSMTP);
  end;
end;

procedure TFrmConfig.FormCreate(Sender: TObject);
var
  Arquivo: TIniFile;
begin
  Arquivo:= TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini'));
  try
    //le dados para interface
    edHost.Text:= Arquivo.ReadString('EMAIL', 'HOST', 'VAZIO');
    edPort.Text:= IntToStr(Arquivo.ReadInteger('EMAIL', 'PORT', 0));
    edUserName.Text:= Arquivo.ReadString('EMAIL', 'USER_NAME', 'VAZIO');
    edSubject.Text:= Arquivo.ReadString('EMAIL', 'SUBJECT', 'VAZIO');
    edPassword.Text:= Arquivo.ReadString('EMAIL', 'PASSWORD', 'VAZIO');
    edPassword.Text:= Descriptografar('7bb7k8', edPassword.Text);
  finally
    Arquivo.Free;
  end;
end;
end.
