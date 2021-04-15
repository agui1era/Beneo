using System;
using System.Text;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.General;
using ITD.Web;
using ITD.Funciones;
using System.IO;
using ITD.Log;
using System.Collections;
using System.Net;
using System.Net.Mail;
using System.Net.Mime;

namespace WEB {
  public partial class Usuario : FrmBase {

    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int IdUsuario = 0;

    SmtpClient cliente;
    MailMessage mm;

    String usuario;
    String contraseña;
    String servidor;
    int puerto;
    bool bolSSL;
    string Url;

    const String cuerpoHtml1 = "...";
    const String cuerpoHtml2 = "...";

    string strIdentificador = "";

    String Msj;

    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniUsuario", "mniConf");
      if (!IsPostBack) {
        CargarGrilla();
        LlenarDDl();
      } else {
        IdUsuario = (int)ViewState["IdUsuario"];
        strIdentificador = ViewState["strIdentificador"].ToString();
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("IdUsuario", IdUsuario);
      ViewState.Add("strIdentificador", strIdentificador);
    }


    private void IniciarParametros() {
      CargarGrilla();
    }

    #endregion

    #region Actualizar        

    private void Insertar() {

      uint uiClave = LongEncript.Encriptar(txtUsuario.Text.ToUpper(), txtUsuario.Text.ToUpper());

      object[] objParam = new object[] {
        0,
        txtNombre.Text,
        txtUsuario.Text,
        uiClave,
        chkAdministrador.Checked,
        ddlTipo.SelectedValue,
        txtEmail.Text,
        //txtFono.Text,
        txtCelular.Text,
        txtObservaciones.Text,
        chkActivo.Checked
        //""
      };

      if (objApp.Ejecutar("AccUsuarioIns", objParam)) {
        IdUsuario = (int)objParam[0];
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Eliminar() {
      object[] objParam = new object[] {
        IdUsuario
      };

      if (objApp.Ejecutar("AccUsuariosDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      object[] objParam = new object[] {
        IdUsuario,
        txtNombre.Text,
        txtUsuario.Text,
        chkAdministrador.Checked,
        //ddlPerfil.SelectedValue,
        ddlTipo.SelectedValue,
        txtEmail.Text,
        //txtFono.Text,
        txtCelular.Text,
        txtObservaciones.Text,
        chkActivo.Checked
        //""
      };

      if (objApp.Ejecutar("AccUsuarioUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void ModificarClave() {
      object[] objParam = new object[] {
        IdUsuario,
        null,
        1
      };

     if (objApp.Ejecutar("AccUsuarioUpdClave", objParam)) {
        miMaster.MensajeInformacion(this);
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }
    public override string ProcesarError(ITDError error) {
      if (error.Mensaje.Contains("IX_AccUsuario"))
        return "Ya existe las siglas del usuario";

      return base.ProcesarError(error);
    }

    #endregion

    #region Interfaz   

    private bool Validar() {
      StringBuilder stbError = new StringBuilder();

      if (string.IsNullOrWhiteSpace(txtNombre.Text))
        stbError.AppendLine("Nombre es requerido.");

      if (string.IsNullOrWhiteSpace(txtUsuario.Text))
        stbError.AppendLine("Sigla Usuario es requerido.");

      if (string.IsNullOrWhiteSpace(ddlTipo.SelectedValue))
        stbError.AppendLine("Tipo es requerido.");

      if (string.IsNullOrWhiteSpace(txtEmail.Text))
        stbError.AppendLine("Email es requerido.");


      if (stbError.Length > 0) {
        stbError.Insert(0, "Existen campos con errores: \n");
        stbError.Replace("\n", "<br>");
        miMaster.MensajeError(this, Global.ERROR, stbError.ToString());
        return false;
      }
      return true;
    }
    private void LimpiarControles() {
      IdUsuario = 0;
      txtNombre.Text = null;
      txtUsuario.Text = null;
      chkAdministrador.Checked = false;
      chkActivo.Checked = false;
      ddlTipo.SelectedIndex = -1;
      txtEmail.Text = null;
      //txtFono.Text = null;
      txtCelular.Text = null;
      txtObservaciones.Text = null;
    }

    private void CargarGrilla() {

      DataTable dttTabla = objApp.TraerTabla("AccUsuarioSel_Grids");

      if (dttTabla != null) {
        RefrescarGrilla(dtgUsuarios, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
          return;
        }
      }
    }

    private void LlenarDDl() {
      LlenarddlTipo(false);
      //LlenarddlPerfil(false);
    }

    private void LlenarControles() {

      DataSet dt = objApp.TraerDataset("AccUsuarioSel_Id", new object[] { IdUsuario.ToString() });

      if (dt != null && dt.Tables[0].Rows.Count > 0) {
        DataRow dtr = dt.Tables[0].Rows[0];

        IdUsuario = (int)dtr["Id"];
        txtNombre.Text = dtr["nombre_empleado"].ToString(); ;
        txtUsuario.Text = dtr["usu_usuario"].ToString(); ;
        chkAdministrador.Checked = Convert.ToBoolean(dtr["Administrador"]);
        ddlTipo.SelectedValue = dtr["IdUsuarioTipo"].ToString();
        txtEmail.Text = dtr["Email"].ToString();
        //txtFono.Text = dtr["Telefono"].ToString();
        txtCelular.Text = dtr["Celular"].ToString();
        txtObservaciones.Text = dtr["Observacion"].ToString();
        chkActivo.Checked = Convert.ToBoolean(dtr["Activo"]);
        strIdentificador = dtr["Identificador"].ToString();
        btnNuevo.Enabled = true;
        btnEliminar.Enabled = true;
        btnGuardar.Enabled = true;
      }
    }

    #endregion

    #region Acciones

    private bool LlenarddlTipo(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheUsuarioTipo");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }

      if (dt == null) {
        dt = new DataTable();
        dt.Columns.Add("Id");
        dt.Columns.Add("Tipo");
      }

      ddlTipo.DataSource = new DataView(dt, "Id > 0", "Tipo", DataViewRowState.OriginalRows);
      ddlTipo.DataBind();

      return true;
    }

    //private bool LlenarddlPerfil(bool bolMostrarMensaje) {
    //  DataTable dt = objApp.TraerTabla("CacheUsuarioPerfil");

    //  if (dt == null && bolMostrarMensaje) {
    //    miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

    //    return false;
    //  }

    //  if (dt == null) {
    //    dt = new DataTable();
    //    dt.Columns.Add("Id");
    //    dt.Columns.Add("Perfil");
    //  }

    //  ddlPerfil.DataSource = new DataView(dt, "Id > 0", "Perfil", DataViewRowState.OriginalRows);
    //  ddlPerfil.DataBind();

    //  return true;
    //}

    public void EnviarEmail() {

      DataSet dt = objApp.TraerDataset("ConfiguracionSel_Id");

      if (dt != null && dt.Tables[0].Rows.Count > 0) {
        DataRow dtr = dt.Tables[0].Rows[0];

        usuario = dtr["UsuarioSMTP"].ToString();
        contraseña = dtr["Clave"].ToString();
        servidor = dtr["ServidorSMTP"].ToString();
        puerto = Convert.ToInt32(dtr["PuertoSMTP"]);
        Url = dtr["URLSistema"].ToString();
        bolSSL = Convert.ToBoolean(dtr["SSL"]);


      }
    }

    public Boolean enviarEmail(String destinatario, String asunto, String mensaje) {
      String cuerpoCompleto = "";

      cliente = new SmtpClient();
      cliente.Port = puerto;
      cliente.Host = servidor;
      cliente.EnableSsl = bolSSL;
      cliente.Timeout = 100000;
      cliente.DeliveryMethod = SmtpDeliveryMethod.Network;
      cliente.UseDefaultCredentials = false;
      cliente.Credentials = new System.Net.NetworkCredential(usuario, contraseña);

      cuerpoCompleto = cuerpoHtml1 + "<br/><br/><p>" + mensaje + "</p><br/><br/>" + cuerpoHtml2;
      mm = new MailMessage(usuario, destinatario, asunto, cuerpoCompleto);
      mm.IsBodyHtml = true;
      mm.BodyEncoding = System.Text.Encoding.UTF8;
      mm.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

      cliente.Send(mm);

      //Cuando el correo se envia, debes marcar en el usuario, el cambiar clave en 1
      return true;
    }

    #endregion

    #region Eventos de Barra

    #endregion

    #region Eventos de Controles
    protected void btnGuardar_Click(object sender, EventArgs e) {
      if (!Validar())
        return;

      if (IdUsuario == 0)
        Insertar();
      else
        Modificar();
    }

    public void btnEliminar_Click(object sender, EventArgs e) {
      //ScriptManager.RegisterStartupScript(Page, Page.GetType(), "ConfirmacionEliminacion", "$(\"#ConfirmacionEliminacion\").modal(\"show\");", true);
      Eliminar();
    }

    protected void btnNuevo_Click(object sender, EventArgs e) {
      LimpiarControles();
    }

    protected void btnResetear_Click(object sender, EventArgs e) {

      string Asunto = "Resetear Contraseña";
      string postData = "Usuario=" + strIdentificador;
      EnviarEmail();
      Msj = Url + "/RecuperarClave.aspx?" + postData;
      if (enviarEmail(txtEmail.Text, Asunto, Msj)){
        ModificarClave();
      }
    }
    #endregion

    #region Eventos de Grillas

    protected void dtgUsuarios_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgUsuarios.PageIndex = e.NewPageIndex;
      dtgUsuarios.DataBind();
      CargarGrilla();
    }

    protected void dtgUsuarios_RowCommand(object sender, GridViewCommandEventArgs e) {
      IdUsuario = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Modificar") {
        LlenarControles();
      }
    }

    protected void dtgUsuarios_DataBound(object sender, EventArgs e) {
      if (dtgUsuarios.HeaderRow != null)
        dtgUsuarios.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgUsuarios_RowCreated(object sender, GridViewRowEventArgs e) {

      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }
    #endregion

    #region Persistencia 

    #endregion

  }
}