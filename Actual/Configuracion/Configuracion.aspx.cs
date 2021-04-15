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


namespace WEB {
  public partial class Configuracion : FrmBase {
    
    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int IdConfiguracion = 0;

    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniConfiguracion", "mniConf");
      if (!IsPostBack) {
        IniciarParametros();
      }
    }

    private void IniciarParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);

      LlenarControles();
    }

    #endregion

    #region Actualizar        

        
    private void Modificar() {
      object[] objParam = new object[] {
        txtId.Text,
        txtServidor.Text,
        txtPuerto.Text,
        chkSSL.Checked,
        txtUsuario.Text,
        txtClave.Text
      };

      if (!objApp.Ejecutar("ConfiguracionUpd", objParam)) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    #endregion

    #region Interfaz        

    private void LlenarControles() {

      DataSet dt = objApp.TraerDataset("ConfiguracionSel_Id");

      if (dt != null && dt.Tables[0].Rows.Count > 0) {
        DataRow dtr = dt.Tables[0].Rows[0];

        txtId.Text = dtr["Id"].ToString();
        txtServidor.Text = dtr["ServidorSMTP"].ToString();
        txtPuerto.Text = dtr["PuertoSMTP"].ToString();
        txtUsuario.Text = dtr["UsuarioSMTP"].ToString();
        txtClave.Text = dtr["Clave"].ToString();
        chkSSL.Checked = Convert.ToBoolean(dtr["SSL"]);
      }

    }
    

    #endregion

    #region Acciones

    #endregion

    #region Eventos de Barra

    #endregion

    #region Eventos de Controles

    
    public void btnActualizar_Click(object sender, EventArgs e) {
      Modificar();
      LlenarControles();
    }

    #endregion

    #region Eventos de Grillas

   

    #endregion


    #region Persistencia 

    #endregion


  }
}