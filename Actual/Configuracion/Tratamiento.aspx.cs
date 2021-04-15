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
  public partial class Tratamiento : FrmBase {
    
    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int IdTratamiento;

    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniTratamiento", "mniConf");
      if (!IsPostBack) {
        IniciarParametros();
        LimpiarControles();
      } else {
        IdTratamiento = (int)ViewState["IdTratamiento"];
      }
    }
    

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("IdTratamiento", IdTratamiento);
    }


    private void IniciarParametros() {
      CargarGrilla();
    }

    #endregion

    #region Actualizar        

    private void Insertar() {
      object[] objParam = new object[] {
        0,
        txtCodigo.Text,
        txtNombre.Text,
        chkActivo.Checked,
        objApp.InfoUsr.IdUsuario
      };

      if (objApp.Ejecutar("TratamientoIns", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Eliminar() {
      object[] objParam = new object[] {
        IdTratamiento
      };

      if (objApp.Ejecutar("TratamientoDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      object[] objParam = new object[] {
        IdTratamiento,
        txtCodigo.Text,
        txtNombre.Text,
        chkActivo.Checked,
        objApp.InfoUsr.IdUsuario
      };

      if (objApp.Ejecutar("TratamientoUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    #endregion

    #region Interfaz        

    private bool Validar() {
      StringBuilder stbError = new StringBuilder();

      if (string.IsNullOrWhiteSpace(txtCodigo.Text))
        stbError.AppendLine("Código es requerido.");

      if (string.IsNullOrWhiteSpace(txtNombre.Text))
        stbError.AppendLine("Nombre es requerido.");

      if (stbError.Length > 0) {
        stbError.Insert(0, "Existen campos con errores: \n");
        stbError.Replace("\n", "<br>");
        miMaster.MensajeError(this, Global.ERROR, stbError.ToString());
        return false;
      }
      return true;
    }

    private void LimpiarControles() {
      IdTratamiento = 0;
      txtCodigo.Text = null;
      txtNombre.Text = null;
      chkActivo.Checked = true;
      btnNuevo.Enabled = false;
      btnEliminar.Enabled = false;
      btnGuardar.Enabled = true;
    }

    private void CargarGrilla() {

      DataTable dttTabla = objApp.TraerTabla("TratamientoSel_Grids");

      if (dttTabla != null) {
        RefrescarGrilla(dtgTratamiento, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
          return;
        }
      }
    }

    #endregion

    #region Acciones

    #endregion

    #region Eventos de Barra

    #endregion

    #region Eventos de Controles

    protected void btnGuardar_Click(object sender, EventArgs e) {
      if (!Validar())
        return;

      if (IdTratamiento == 0)
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

    #endregion

    #region Eventos de Grillas

    protected void dtgTratamiento_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgTratamiento.PageIndex = e.NewPageIndex;
      dtgTratamiento.DataBind();
      CargarGrilla();
    }

    protected void dtgTratamiento_RowCommand(object sender, GridViewCommandEventArgs e) {
      IdTratamiento = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Modificar") {

        DataSet dt = objApp.TraerDataset("TratamientoSel_Id", new object[] { IdTratamiento.ToString() });

        if (dt != null && dt.Tables[0].Rows.Count > 0) {
          DataRow dtr = dt.Tables[0].Rows[0];

          IdTratamiento = (int)dtr["Id"];
          txtCodigo.Text = dtr["Codigo"].ToString();
          txtNombre.Text = dtr["Nombre"].ToString();
          chkActivo.Checked = Convert.ToBoolean(dtr["Activo"]);
          btnNuevo.Enabled = true;
          btnEliminar.Enabled = true;
          btnGuardar.Enabled = true;
        }
      }
    }

    #endregion

    #region Persistencia 

    #endregion

  }
}