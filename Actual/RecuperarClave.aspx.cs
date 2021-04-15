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

namespace WEB {
  public partial class RecuperarClave : FrmBase {
    
    #region Declaraciones 

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    string strIdentificador;
    string strEmail;
    string strusu_usuario;
    int intIdUsuario;

    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      if (!IsPostBack) {
        strIdentificador = Request.QueryString["Usuario"];

        if (string.IsNullOrEmpty(strIdentificador)) {
          LlamarFormulario("Login", null);
        }
        else{
          TraerInfoUsuario();
        }

        
      }
      else{
        strIdentificador = ViewState["strIdentificador"].ToString();
        strEmail = ViewState["strEmail"].ToString();
        strusu_usuario = ViewState["strusu_usuario"].ToString();
        intIdUsuario = (int)ViewState["intIdUsuario"];
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      //ViewState.Add("IdUsuario", IdUsuario);
      ViewState.Add("strIdentificador", strIdentificador);
    }

    #endregion

    #region Actualizar        

    private void ModificarClave() {

      uint uiClave = LongEncript.Encriptar(strusu_usuario.ToUpper(), txtConfirmPass.Text);

      object[] objParam = new object[] {
        intIdUsuario,
        uiClave,
        0
      };

      if (objApp.Ejecutar("AccUsuarioUpdClave", objParam)) {

        ClaseGeneral.RESULTADO_ACCESO resultado = objApp.VerificarAccesoCliente(strusu_usuario.ToUpper(), txtConfirmPass.Text);
        if (resultado == ClaseGeneral.RESULTADO_ACCESO.Ok) {
          lblError.Text = "";
          Response.Redirect("Inicial/Forma.aspx");
        } else {
          lblError.Text = resultado == ClaseGeneral.RESULTADO_ACCESO.ClaveErronea ? "Clave invalida" : resultado == ClaseGeneral.RESULTADO_ACCESO.NoExiste ? "No existe." : "Error desconocido";
        }
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    #endregion

    #region Interfaz        

    private bool validar() {
      System.Text.StringBuilder stb = new System.Text.StringBuilder();
      if (string.IsNullOrWhiteSpace(txtPassword.Text)) {
        stb.AppendLine("Debe ingresar Password");
      }
      
      if (txtPassword.Text != txtConfirmPass.Text) {
        stb.AppendLine("Confirmación de Password incorrecta.");
      }
      lblError.Text = stb.ToString();
      return string.IsNullOrWhiteSpace(stb.ToString());
    }

    public void TraerInfoUsuario() {
      DataSet dt = objApp.TraerDataset("AccUsuarioSel_Identificador", new object[] { strIdentificador });

      if (dt != null && dt.Tables[0].Rows.Count > 0) {
        DataRow dtr = dt.Tables[0].Rows[0];

        ViewState.Add("strEmail", dtr["Email"].ToString()) ;
        ViewState.Add("strusu_usuario", dtr["usu_usuario"].ToString());
        ViewState.Add("intIdUsuario", dtr["Id"]);
      }
    }

    #endregion

    #region Acciones

    #endregion

    #region Eventos de Barra

    #endregion

    #region Eventos de Controles

    protected void btnSubmit_Click(object sender, EventArgs e) {
      if (validar()) {
        //guardar nueva clave
        ModificarClave();
      }
    }

    protected void txtConfirmPass_TextChanged(object sender, EventArgs e) {
      if (!string.IsNullOrEmpty(txtConfirmPass.Text))
          lblError.Text = "";
    }

    protected void txtPassword_TextChanged(object sender, EventArgs e) {
      if (!string.IsNullOrEmpty(txtPassword.Text))
        lblError.Text = "";
    }
    #endregion

    #region Eventos de Grillas

    #endregion


    #region Persistencia 

    #endregion


  }
}