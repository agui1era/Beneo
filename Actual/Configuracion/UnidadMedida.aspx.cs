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

namespace WEB {
  public partial class UnidadMedida : FrmBase {

    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }
    int IdActividad;
    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniUniMed", "mniConf");
      if (!IsPostBack) {
    
        IniciarParametros();
        LimpiarControles();
      } else {
        
        IdActividad = (int)ViewState["IdActividad"];
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("IdActividad", IdActividad);
    }

    private void IniciarParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);
      
      CargarGrilla();
    }

    #endregion

    #region Actualizar        

    private void Insertar() {
      object[] objParam = new object[] {
        0,
        txtSigla.Text,
        txtNombre.Text,
        Global.convertiraNumero(txtFactor.Text),
        chkBase.Checked,
        string.IsNullOrWhiteSpace(ddlUMBase.SelectedValue) ? null : ddlUMBase.SelectedValue
      };

      if (objApp.Ejecutar("UnidadMedidaIns", objParam)) {
        IdActividad = (int)objParam[0];
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Eliminar() {
      object[] objParam = new object[] {
        IdActividad
      };

      if (objApp.Ejecutar("UnidadMedidaDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      object[] objParam = new object[] {
        IdActividad,
        txtSigla.Text,
        txtNombre.Text,
        Global.convertiraNumero(txtFactor.Text),
        chkBase.Checked,
        string.IsNullOrWhiteSpace(ddlUMBase.SelectedValue) ? null : ddlUMBase.SelectedValue
      };

      if (objApp.Ejecutar("UnidadMedidaUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    public override string ProcesarError(ITDError error) {
      if (error.Mensaje.Contains("IX_Actividad_1"))
        return "Ya existe la actividad";

      return base.ProcesarError(error);
    }

    #endregion

    #region Interfaz        

    #region Ddls
    private void LlenarDdls() {
      LlenarddlUMBase(false);
      //LlenarddlProducto(false);
    }


    private bool LlenarddlUMBase(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheUnidadMedida");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }
      if (dt != null)

        if (dt == null) {
          dt = new DataTable();
          dt.Columns.Add("Id");
          dt.Columns.Add("Nombre");
        }

      ddlUMBase.DataSource = new DataView(dt, "Id is null or Base = 1", "Sigla", DataViewRowState.OriginalRows);
      ddlUMBase.DataBind();

      return true;
    }

    #endregion

    private bool Validar() {
      StringBuilder stbError = new StringBuilder();

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
      LlenarDdls();
      IdActividad = 0;
      txtNombre.Text = null;
      txtSigla.Text = null;
      txtFactor.Text = null;
      ddlUMBase.SelectedIndex = -1;
      chkBase.Checked = false;
      chkBase_CheckedChanged(null, null);
      btnNuevo.Enabled = false;
      btnEliminar.Enabled = false;
      btnGuardar.Enabled = true;
    }

    private void CargarGrilla() {
      //coment
      DataTable dttTabla = objApp.TraerTabla("UnidadMedidaSel_Grids");

      if (dttTabla != null) {
        RefrescarGrilla(dtgActividad, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
          return;
        }
      }
    }

    private void LlenarControles() {
      DataSet dt = objApp.TraerDataset("UnidadMedidaSel_Id", new object[] { IdActividad });
      if (dt != null && dt.Tables[0].Rows.Count > 0) {
        DataRow dtr = dt.Tables[0].Rows[0];

        LlenarDdls();

        ddlUMBase.SelectedValue = dtr["IdUMBase"].ToString();
        IdActividad = (int)dtr["Id"];
        chkBase.Checked = (bool)dtr["Base"];
        chkBase_CheckedChanged(null, null);
        txtNombre.Text = dtr["Nombre"].ToString();
        txtSigla.Text = dtr["Sigla"].ToString();
        txtFactor.Text = dtr.IsNull("Factor") ? "0" : ((decimal)dtr["Factor"]).ToString("#,##0.##");
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

      if (IdActividad == 0)
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

    protected void chkBase_CheckedChanged(object sender, EventArgs e) {
      if (chkBase.Checked) {
        txtFactor.Text = "1";
        ddlUMBase.Enabled = false;
        txtFactor.ReadOnly = true;
        ddlUMBase.SelectedIndex = -1;
      }
      else{
        txtFactor.Text = "";
        ddlUMBase.Enabled = true;
        txtFactor.ReadOnly = false;
      }
    }

    #endregion

    #region Eventos de Grillas

    protected void dtgActividad_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgActividad.PageIndex = e.NewPageIndex;
      dtgActividad.DataBind();
      CargarGrilla();
    }

    protected void dtgActividad_RowCommand(object sender, GridViewCommandEventArgs e) {
      IdActividad = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Modificar") {
        LlenarControles();
      }
    }


    protected void dtgActividad_DataBound(object sender, EventArgs e) {
      if (dtgActividad.HeaderRow != null)
        dtgActividad.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgActividad_RowCreated(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }
    #endregion

    #region Persistencia 

    #endregion

  }
}