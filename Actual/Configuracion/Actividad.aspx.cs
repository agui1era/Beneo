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
  public partial class Actividad : FrmBase {

    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }
    int IdActividad;
    int IdProducto;
    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniActividad", "mniConf");
      if (!IsPostBack) {
        object objParam = TraerParametro(typeof(Producto));
        if (objParam != null)
          IdProducto = Convert.ToInt32(objParam);
        LlenarDdls();
        IniciarParametros();
        LimpiarControles();
      } else {

        IdProducto = Convert.ToInt32(ViewState["IdProducto"]);
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
        txtNombre.Text,
        chkActivo.Checked,
        objApp.InfoUsr.IdUsuario,
        Global.ObtenerSeleccionados(lstCategoria),
        Global.ObtenerSeleccionados(lstHerramientas)

      };

      if (objApp.Ejecutar("ActividadIns", objParam)) {
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

      if (objApp.Ejecutar("ActividadDel", objParam)) {
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
        txtNombre.Text,
        chkActivo.Checked,
        objApp.InfoUsr.IdUsuario,
        Global.ObtenerSeleccionados(lstCategoria),
        Global.ObtenerSeleccionados(lstHerramientas)
      };

      if (objApp.Ejecutar("ActividadUpd", objParam)) {
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
      IdActividad = 0;
      txtNombre.Text = null;
      chkActivo.Checked = true;
      lstCategoria.ClearSelection();
      lstHerramientas.ClearSelection();

      txtNombre.Visible = false;
      LlenarddlActividad(false, "");
      ddlActividadExiste.Visible = true;
      btnNuevaAct.Visible = true;

      btnNuevo.Enabled = false;
      btnEliminar.Enabled = false;
      btnGuardar.Enabled = true;
    }

    private void CargarGrilla() {
      //coment
      DataTable dttTabla = objApp.TraerTabla("ActividadSel_Grids");

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
      DataSet dt = objApp.TraerDataset("ActividadSel_Id", new object[] { IdActividad });
      if (dt != null && dt.Tables[0].Rows.Count > 0) {
        DataRow dtr = dt.Tables[0].Rows[0];


        ddlActividadExiste.Visible = false;
        btnNuevaAct.Visible = false;
        IdActividad = (int)dtr["Id"];
        txtNombre.Text = dtr["Nombre"].ToString();
        chkActivo.Checked = Convert.ToBoolean(dtr["Activo"]);
        btnNuevo.Enabled = true;
        btnEliminar.Enabled = true;
        btnGuardar.Enabled = true;
        lstCategoria.ClearSelection();
        lstHerramientas.ClearSelection();
        dt.Tables[1].AsEnumerable().ToList().ForEach(s => lstCategoria.Items.FindByValue(s["IdCategoria"].ToString()).Selected = true);
        dt.Tables[2].AsEnumerable().ToList().ForEach(s => lstHerramientas.Items.FindByValue(s["IdCategoriaH"].ToString()).Selected = true);
      }
    }
    
    private void LlenarDdls() {
      LlenarddlProd(false);

      LlenarddlHerramienta(false);
    }

    private bool LlenarddlActividad(bool bolMostrarMensaje, string strNuevo) {
      DataTable dt = objApp.TraerTabla("CacheActividad");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }
      strNuevo = strNuevo.ToUpper();
      if (dt == null) {
        dt = new DataTable();
        dt.Columns.Add("Nombre");
      }

      if (!string.IsNullOrWhiteSpace(strNuevo)) {
        DataRow dtr = dt.NewRow();
        dtr["Nombre"] = strNuevo;
        dt.Rows.Add(dtr);
        dt.AcceptChanges();
      }

      ddlActividadExiste.DataSource = new DataView(dt, "", "Nombre", DataViewRowState.OriginalRows);
      ddlActividadExiste.DataBind();

      if (!string.IsNullOrWhiteSpace(strNuevo)) {
        ddlActividadExiste.SelectedValue = strNuevo;
        ddlActividadExiste.Text = "";
      }

      return true;
    }

    private bool LlenarddlProd(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheCategoria");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }

      if (dt == null) {
        dt = new DataTable();
        dt.Columns.Add("Id");
        dt.Columns.Add("Categoria");
      }

      lstCategoria.DataSource = new DataView(dt, "", "Id", DataViewRowState.OriginalRows);
      lstCategoria.DataBind();

      return true;

    }
    
    /// <summary>
    /// </summary>
    /// <param name="bolMostrarMensaje"></param>
    /// <returns></returns>
    /// 
    private bool LlenarddlHerramienta(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheCategoriaHerr");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }

      if (dt == null) {
        dt = new DataTable();
        dt.Columns.Add("Id");
        dt.Columns.Add("Categoria");
      }

      lstHerramientas.DataSource = new DataView(dt, "", "Id", DataViewRowState.OriginalRows);
      lstHerramientas.DataBind();

      return true;

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

    protected void btnNuevaAct_Click(object sender, EventArgs e) {
      ddlActividadExiste.Visible = false;
      txtNombre.Visible = true;
      btnNuevaAct.Visible = false;
    }
  }
}