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
using static WEB.General.ClaseGeneral;
using System.Web.Services;

namespace WEB {

  public partial class RecepcionDetAct : FrmBase {

    #region Declaraciones 

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }
    DataTable dtProductos = null;
    int intId = 0;
    int intIdRecepcion = 0;
    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {

      if (!IsPostBack) {
        IniciarParametros();

        object objParam = TraerParametro(typeof(RecepcionAct));

        if (objParam != null) {
          intIdRecepcion = Convert.ToInt32(objParam);
        }

        LlenarControles();
        CargarGrilla();
      } else {
        intId = Convert.ToInt32(ViewState["intId"]);
        intIdRecepcion = Convert.ToInt32(ViewState["intIdRecepcion"]);
        dtProductos = (DataTable)ViewState["TablaProductos"];
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("intId", intId);
      ViewState.Add("intIdRecepcion", intIdRecepcion);

    }

    private void IniciarParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);

      LlenarDdls();

      rbtProducto.Checked = true;
    }

    protected override void Render(HtmlTextWriter writer) {
      base.Render(writer);
    }

    #endregion

    #region Actualizar        

    private void Insertar() {
      object[] objParam = new object[] {
        0,
        intIdRecepcion,
        rbtProducto.Checked ? ddlProducto.SelectedValue : null,
        txtCantidad.Text,
        Global.ObtenerFechaPura( txtFechaVcto.Text),
        rbtProducto.Checked ? null : ddlHerramienta.SelectedValue
      };

      if (objApp.Ejecutar("RecepcionDetIns", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }


    private void Eliminar() {
      object[] objParam = new object[] {
        intId,
      };

      if (objApp.Ejecutar("RecepcionDetDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      object[] objParam = new object[] {
        intId,
        intIdRecepcion,
        Global.ObtenerFechaPura( txtFechaVcto.Text),
        rbtProducto.Checked ? ddlProducto.SelectedValue : null,
        txtCantidad.Text,
        ddlHerramienta.SelectedValue,
        rbtProducto.Checked ? null : ddlHerramienta.SelectedValue
      };

      if (objApp.Ejecutar("RecepcionDetUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    #endregion

    #region Interfaz     

    #region Ddls
    private void LlenarDdls() {
      LlenarddlProducto(false);
      LlenarddlHerramienta(false);
    }

    private bool LlenarddlProducto(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheProducto");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }
      if (dt != null)

        if (dt == null) {
          dt = new DataTable();
          dt.Columns.Add("IdProducto");
          dt.Columns.Add("Descripcion");

        }

      ViewState.Add("TablaProductos",dt);

      ddlProducto.DataSource = new DataView(dt, "", "Descripcion", DataViewRowState.OriginalRows);
      ddlProducto.DataBind();

      return true;
    }

    private bool LlenarddlHerramienta(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheHerramienta");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }
      if (dt != null)

        if (dt == null) {
          dt = new DataTable();
          dt.Columns.Add("IdHerramienta");
          dt.Columns.Add("Nombre");

        }
      
      ddlHerramienta.DataSource = new DataView(dt, "", "Nombre", DataViewRowState.OriginalRows);
      ddlHerramienta.DataBind();

      return true;
    }

    #endregion

    public void validar() {
    }

    private void LimpiarControles() {
      intId = -1;
      ddlProducto.SelectedIndex = 0;
      txtCantidad.Text = "";
      txtFechaVcto.Text = "";
      txtUM.Text = "";

      ddlHerramienta.SelectedIndex = 0;
      rbtProducto.Checked = true;
      rbtHerramienta.Checked = false;
      rbtHerramienta_CheckedChanged(null, null);

      btnGuardar.Enabled = true;
      btnEliminar.Enabled = false;
      btnNuevo.Enabled = false;
    }

    private void LlenarControles() {
      DataSet dts = objApp.TraerDataset("RecepcionDetSel_Id", new object[] { intId });

      if (dts != null) {

        if (dts.Tables[0].Rows.Count == 0) {
          LimpiarControles();
          return;
        }

        DataRow dtr = dts.Tables[0].Rows[0];

        ddlProducto.SelectedValue = dtr["IdProducto"].ToString();
        txtCantidad.Text = dtr["Cantidad"].ToString();
        txtFechaVcto.Text = dtr["FechaVcto"].ToString();
        txtUM.Text = dtr["Nombre"].ToString();
        ddlHerramienta.SelectedValue = dtr["IdHerramienta"].ToString();

        if (dtr.IsNull("IdProducto")) {
          rbtHerramienta.Checked = true;
          rbtProducto.Checked = false;
        } else {
          rbtHerramienta.Checked = false;
          rbtProducto.Checked = true;
        }

        rbtHerramienta_CheckedChanged(null, null);

          ESTADO_RECEPCION objEstado = (ESTADO_RECEPCION)(int)dtr["IdEstado"];
        btnGuardar.Enabled = objEstado == ESTADO_RECEPCION.PorRecibir;
        btnEliminar.Enabled = objEstado == ESTADO_RECEPCION.PorRecibir;

      }

    }

    private void CargarGrilla() {

      object[] objParam = new object[] { intIdRecepcion };

      DataTable dtsTabla = objApp.TraerTabla("RecepcionDetSel_Grids", objParam, 60);

      if (dtsTabla != null) {

        RefrescarGrilla(dtgPrincipal, dtsTabla.DefaultView, false);

      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          //PopUpModal.Show();
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
      if (intId <= 0)
        Insertar();
      else
        Modificar();
    }

    public void btnEliminar_Click(object sender, EventArgs e) {
      Eliminar();
    }

    protected void btnNuevo_Click(object sender, EventArgs e) {
      LimpiarControles();
    }

    protected void ddlProducto_SelectedIndexChanged(object sender, EventArgs e) {

      DataRow dtr = dtProductos.AsEnumerable().Where(s => !s.IsNull("IdProducto") && Convert.ToInt32(s["IdProducto"]) == Convert.ToInt32(ddlProducto.SelectedValue)).SingleOrDefault();

      if (dtr != null)
        txtUM.Text = dtr["Nombre"].ToString();

    }

    protected void rbtHerramienta_CheckedChanged(object sender, EventArgs e) {
      ddlProducto.Visible = rbtProducto.Checked;
      ddlHerramienta.Visible = !rbtProducto.Checked;

      if (rbtProducto.Checked)
        lblProducto.InnerText = "Producto";
      else
        lblProducto.InnerText = "Herramienta";
    }

    #endregion

    #region Eventos de Grillas
    protected void dtgPrincipal_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgPrincipal.PageIndex = e.NewPageIndex;
    }

    protected void dtgPrincipal_Sorting(object sender, GridViewSortEventArgs e) {
      SetearOrdenGrilla(dtgPrincipal, e.SortExpression);
    }

    protected void dtgPrincipal_RowCommand(object sender, GridViewCommandEventArgs e) {
      intId = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Modificar") {
        LlenarControles();
      }
    }

    protected void dtgPrincipal_DataBound(object sender, EventArgs e) {
      if (dtgPrincipal.HeaderRow != null)
        dtgPrincipal.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    #endregion

    #region Persistencia 

    #endregion

  }
  
}