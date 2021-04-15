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
  public partial class Bodegas : FrmBase {

    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int IdBodega;

    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniBodega", "mniBodega");
      if (!IsPostBack) {
        IniciarParametros();        
        LlenarDdls();
        LimpiarControles();
      } else {
        IdBodega = (int)ViewState["IdBodega"];
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("IdBodega", IdBodega);
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
        ddlLugar.SelectedValue,
        txtCodigo.Text,
        txtNombre.Text,
        chkActivo.Checked,
        objApp.InfoUsr.IdUsuario
      };

      if (objApp.Ejecutar("BodegaIns", objParam)) {
        IdBodega = (int)objParam[0];
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Eliminar() {
      object[] objParam = new object[] {
        IdBodega
      };

      if (objApp.Ejecutar("BodegaDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      object[] objParam = new object[] {
        IdBodega,
        ddlLugar.SelectedValue,
        txtCodigo.Text,
        txtNombre.Text,
        chkActivo.Checked,
        objApp.InfoUsr.IdUsuario
      };

      if (objApp.Ejecutar("BodegaUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    public override string ProcesarError(ITDError error) {
      if (error.Mensaje.Contains("IX_Lugar"))
        return "Ya existe el código para la temporada seleccionada";

      if (error.Mensaje.Contains("IX_Lugar"))
        return "Ya existe el lugar para la temporada seleccionada";

      return base.ProcesarError(error);
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
      IdBodega = 0;
      txtCodigo.Text = null;
      txtNombre.Text = null;
      chkActivo.Checked = true;
      ddlLugar.SelectedIndex = -1;
      btnNuevo.Enabled = false;
      btnEliminar.Enabled = false;
      btnGuardar.Enabled = true;
    }

    private void CargarGrilla() {

      DataTable dttTabla = objApp.TraerTabla("BodegaSel_Grids");

      if (dttTabla != null) {
        RefrescarGrilla(dtgBodegas, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
          return;
        }
      }
    }

    private void LlenarDdls() {
      LlenarddlLugar(false);
    }

    private bool LlenarddlLugar(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheLugar");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }

        if (dt == null) {
          dt = new DataTable();
          dt.Columns.Add("Id");
          dt.Columns.Add("Nombre");
        }

      ddlLugar.DataSource = new DataView(dt, "Id > 0", "Nombre", DataViewRowState.OriginalRows);
      ddlLugar.DataBind();

      return true;
    }

    private void LlenarControles() {

      DataSet dt = objApp.TraerDataset("BodegaSel_Id", new object[] { IdBodega });

      if (dt != null && dt.Tables[0].Rows.Count > 0) {
        DataRow dtr = dt.Tables[0].Rows[0];

        IdBodega = (int)dtr["Id"];
        txtCodigo.Text = dtr["Codigo"].ToString();
        txtNombre.Text = dtr["Nombre"].ToString();
        ddlLugar.SelectedValue = dtr["IdLugar"].ToString();
        chkActivo.Checked = Convert.ToBoolean(dtr["Activo"]);
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

      if (IdBodega == 0) {
        Insertar();
        LimpiarControles();
      } else
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

    protected void dtgBodegas_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgBodegas.PageIndex = e.NewPageIndex;
      dtgBodegas.DataBind();
      CargarGrilla();
    }

    protected void dtgBodegas_RowCommand(object sender, GridViewCommandEventArgs e) {
      IdBodega = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Modificar") {
        LlenarControles();
      }
    }

    protected void dtgBodegas_DataBound(object sender, EventArgs e) {
      if (dtgBodegas.HeaderRow != null)
        dtgBodegas.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgBodegas_RowCreated(object sender, GridViewRowEventArgs e) {

      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }

    #endregion

    #region Persistencia 

    #endregion

  }
}