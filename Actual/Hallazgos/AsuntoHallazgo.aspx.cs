using ITD.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.General;

namespace WEB.Hallazgos {
  public partial class AsuntoHallazgo : FrmBase {


    #region Declaraciones
    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int IdAsunto = 0;
    #endregion

    #region Inicial 
    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniAsuntoH", "mniHallazgos");

      if (!IsPostBack) {
        IniciarParametros();
        LimpiarControles();
        CargarGrilla();
      } else {
        IdAsunto = (int)ViewState["Id"];
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("Id", IdAsunto);
    }
    #endregion

    #region Actualizar


    private void Insertar() {
      object[] objParam = new object[] {
        0,
        txtAsunto.Text,
        chkActivo.Checked
      };

      if (objApp.Ejecutar("HallazgoAsuntoIns", objParam)) {
        IdAsunto = (int)objParam[0];
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Eliminar() {
      object[] objParam = new object[] {
        IdAsunto
      };

      if (objApp.Ejecutar("HallazgoAsuntoDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      object[] objParam = new object[] {
        IdAsunto,
        txtAsunto.Text,
        chkActivo.Checked
      };

      if (objApp.Ejecutar("HallazgoAsuntoUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    #endregion

    #region Interfaz

    private bool Validar() {
      StringBuilder stbError = new StringBuilder();

      if (string.IsNullOrWhiteSpace(txtAsunto.Text))
        stbError.AppendLine("Producto es requerido.");

      if (stbError.Length > 0) {
        stbError.Insert(0, "Existen campos con errores: \n");
        stbError.Replace("\n", "<br>");
        miMaster.MensajeError(this, Global.ERROR, stbError.ToString());
        return false;
      }
      return true;
    }

    private void LimpiarControles() {
      IdAsunto = 0;
      txtAsunto = null;
      chkActivo.Checked = true;
      btnNuevo.Enabled = false;
      btnEliminar.Enabled = false;
      btnGuardar.Enabled = true;
    }

    private void CargarGrilla() {

      DataTable dttTabla = objApp.TraerTabla("HallazgoAsuntoSel_Grids");

      if (dttTabla != null) {
        RefrescarGrilla(dtgAsunto, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
          return;
        }
      }
    }

   

    private void LlenarControles() {

      DataSet dt = objApp.TraerDataset("HallazgoAsuntoSel_Id", new object[] { IdAsunto });

      if (dt != null && dt.Tables[0].Rows.Count > 0) {
        DataRow dtr = dt.Tables[0].Rows[0];

        IdAsunto = (int)dtr["Id"];
        txtAsunto.Text = dtr["Asunto"].ToString();
        chkActivo.Checked = (bool)dtr["Activo"];

        btnNuevo.Enabled = true;
        btnEliminar.Enabled = true;
        btnGuardar.Enabled = true;
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

      if (IdAsunto == 0)
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

    protected void dtgAsunto_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgAsunto.PageIndex = e.NewPageIndex;
      dtgAsunto.DataBind();
      CargarGrilla();
    }

    protected void dtgAsunto_RowCommand(object sender, GridViewCommandEventArgs e) {
      IdAsunto = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Modificar") {
        LlenarControles();
      }
    }

    protected void dtgAsunto_DataBound(object sender, EventArgs e) {
      if (dtgAsunto.HeaderRow != null)
        dtgAsunto.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgAsunto_RowCreated(object sender, GridViewRowEventArgs e) {

      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }


    #endregion


    #region Persistencia
    #endregion







  }
}