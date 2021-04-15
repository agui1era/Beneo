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
using System.Globalization;

namespace WEB {
  public partial class Asignacion : FrmBase {

    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int ProgActId = 0;

    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniAsignacion", "mniProgra");
      if (!IsPostBack) {
        InicializarFiltros();

        LlenarDdls();
        IniciaParametros();
        dtgPrincipal.PageSize = 20;

        Filtrar();

      } else {
        //dttDdls = (DataTable)ViewState["dttDdls"];
        ProgActId = Convert.ToInt32(ViewState["ActId"]);
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("ProgActId", ProgActId);
    }

    public override void InicializarFiltros() {
      base.InicializarFiltros();
      Filtro.Agregar(new FiltroDropDown(ddlTemporada, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Programacion.IdTemporada", "Temporada", TipoDatos.Entero));
      Filtro.Agregar(new FiltroTextBox(txtFechaDesde, OpcSeleccion.ControlConValor, TipoOperadores.MayorIgual, "DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde )", "FechaDesde", TipoDatos.Fecha));
      Filtro.Agregar(new FiltroTextBox(txtFechaHasta, OpcSeleccion.ControlConValor, TipoOperadores.MenorIgual, "DATEADD(day, ProgramacionDia.IdDia - 1,  ProgramacionActividad.FechaDesde )", "FechaHasta", TipoDatos.Fecha));
      Filtro.Agregar(new FiltroDropDown(ddlLugar, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Programacion.IdLugar", "Lugar", TipoDatos.Entero));
      Filtro.Agregar(new FiltroDropDown(ddlEnsayo, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Programacion.IdEnsayo", "Ensayo", TipoDatos.Entero));
    }

    private void IniciaParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);

      txtFechaDesde.Text = DateTime.Now.Date.ToString("dd/MM/yyyy");
      txtFechaHasta.Text = DateTime.Now.Date.ToString("dd/MM/yyyy");
      this.SalvaForma = true;

    }

    #endregion

    #region Actualizar        

    private void Insertar() {

      object[] objParam = new object[] {
        txtProgActId.Text,
        txtIdTemporada.Text,
        txtFechaAct.Text,
        txtIdLugar.Text,
        txtIdEnsayo.Text,
        Global.ObtenerSeleccionados(lstUsuario)
      };

      if (objApp.Ejecutar("AsignacionActividadIns", objParam)) {
        miMaster.MensajeInformacion(this);
        Filtrar();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }


    #endregion

    #region Interfaz        

    private void LlenarDdls() {
      LlenarddlTemporada(false); 
    }

    private bool LlenarddlTemporada(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheTemporada");

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

      ddlTemporada.DataSource = new DataView(dt, "", "Nombre", DataViewRowState.CurrentRows);
      ddlTemporada.DataBind();
      LlenarddlLugar(false, string.IsNullOrWhiteSpace(ddlTemporada.SelectedValue) ? 0 : Convert.ToInt32(ddlTemporada.SelectedValue));
      //LlenarddlEnsayo(false, string.IsNullOrWhiteSpace(ddlLugar.SelectedValue) ? 0 : Convert.ToInt32(ddlLugar.SelectedValue));
      return true;
    }

    private bool LlenarddlLugar(bool bolMostrarMensaje, int intIdTemporada) { 
      DataTable dt = objApp.TraerTabla("CacheLugar");

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

      ddlLugar.DataSource = new DataView(dt, string.Format("IdTemporada={0} or Id is null", intIdTemporada), "Nombre", DataViewRowState.OriginalRows);
      ddlLugar.DataBind();
      LlenarddlEnsayo(false, string.IsNullOrWhiteSpace(ddlLugar.SelectedValue) ? 0 : Convert.ToInt32(ddlLugar.SelectedValue));
      return true;
    }

    private bool LlenarddlEnsayo(bool bolMostrarMensaje, int intIdLugar) {
      DataTable dt = objApp.TraerTabla("CacheEnsayo");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }
      if (dt != null)

        if (dt == null) {
          dt = new DataTable();
          dt.Columns.Add("Id");
          dt.Columns.Add("Codigo");
        }

      ddlEnsayo.DataSource = new DataView(dt, string.Format("IdLugar={0} or Id is null", intIdLugar), "Codigo", DataViewRowState.OriginalRows);
      ddlEnsayo.DataBind();

      return true;
    }

    private bool LlenarlstUsuario(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheResponsable");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }
      if (dt != null)

        if (dt == null) {
          dt = new DataTable();
          dt.Columns.Add("Id");
          dt.Columns.Add("nombre_empleado");
        }

      lstUsuario.DataSource = new DataView(dt, "Id > 0", "nombre_empleado", DataViewRowState.OriginalRows);
      lstUsuario.DataBind();

      return true;
    }

    private void Filtrar() {
      //if (Validar()) {
        if (Filtro == null)
          InicializarFiltros();
        string strError = Filtro.ValidarFiltros();
        if (string.IsNullOrEmpty(strError)) {
          Filtro.FormarFiltro();
          LlenarGrilla();
        } else {
          //miMaster.MostrarMensaje(ClaseGeneral.STR_ERROR, strError);
        }
      //}
    }

    private void LlenarGrilla() {
      object[] objParam;

      objParam = new object[]{
        dtgPrincipal.PageIndex,
        dtgPrincipal.PageSize,
        0,
        TomarOrdenGrilla(dtgPrincipal),
        Filtro.Filtro,
        null
      };

      DataTable dtsTabla = objApp.TraerTabla("AsignacionActividadSel_Grids", objParam, 60);

      if (dtsTabla != null) {
        
        dtgPrincipal.PageIndex = (int)objParam[0];
        RefrescarGrilla(dtgPrincipal, dtsTabla.DefaultView, (int)objParam[2]);
   
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          //PopUpModal.Show();
          return;
        }
      }
      
    }

    public void LlenarControlesActividad() {
      DataSet dts = objApp.TraerDataset("AsignacionActividadSel_Id", new object[] { ProgActId });

      if (dts != null) {

        DataRow dtr = dts.Tables[0].Rows[0];

        txtProgActId.Text = dtr["Id"].ToString();
        txtIdTemporada.Text = dtr["IdTemporada"].ToString();
        txtIdLugar.Text = dtr["IdLugar"].ToString();
        txtIdEnsayo.Text = dtr["IdEnsayo"].ToString();
        txtFechaAct.Text = dtr["FechaDesde"].ToString();
        lstUsuario.ClearSelection();
        dts.Tables[1].AsEnumerable().ToList().ForEach(s => lstUsuario.Items.FindByValue(s["IdUsuario"].ToString()).Selected = true);
      }
    }

   
    #endregion

    #region Acciones

    #endregion

    #region Eventos de Barra

    #endregion

    #region Eventos de Controles

    protected void btnFiltrar_Click(object sender, EventArgs e) {
      Filtrar();
    }


    protected void btnModalGuardar_Click(object sender, EventArgs e) {      
      Insertar();
    }

    protected void ddlTemporada_SelectedIndexChanged(object sender, EventArgs e) {
      LlenarddlLugar(false, string.IsNullOrWhiteSpace(ddlTemporada.SelectedValue) ? 0 : Convert.ToInt32(ddlTemporada.SelectedValue));
      //LlenarddlEnsayo(false, string.IsNullOrWhiteSpace(ddlLugar.SelectedValue) ? 0 : Convert.ToInt32(ddlLugar.SelectedValue));
    }

    protected void ddlLugar_SelectedIndexChanged(object sender, EventArgs e) {
      LlenarddlEnsayo(false, string.IsNullOrWhiteSpace(ddlLugar.SelectedValue) ? 0 : Convert.ToInt32(ddlLugar.SelectedValue));
    }

    #endregion

    #region Eventos de Grillas

    protected void dtgPrincipal_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgPrincipal.PageIndex = e.NewPageIndex;
      dtgPrincipal.DataBind();
      Filtrar();
    }

    protected void dtgPrincipal_Sorting(object sender, GridViewSortEventArgs e) {
      SetearOrdenGrilla(dtgPrincipal, e.SortExpression);
      Filtrar();
    }

    protected void dtgPrincipal_RowCommand(object sender, GridViewCommandEventArgs e) {
      if (e.CommandName == "Asignacion") {
        ScriptManager.RegisterStartupScript(Page, Page.GetType(), "DetalleASignacion", "$(\"#DetalleASignacion\").modal(\"show\");", true);
        LlenarlstUsuario(false);
        ProgActId = Convert.ToInt32(e.CommandArgument);
        LlenarControlesActividad();
      }
      
    }

    protected void dtgPrincipal_RowCreated(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      } 
    }

    protected void dtgPrincipal_DataBound(object sender, EventArgs e) {
      if(dtgPrincipal.HeaderRow != null)
        dtgPrincipal.HeaderRow.TableSection = TableRowSection.TableHeader;
      

    }

    protected void dtgPrincipal_RowDataBound(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.DataRow) {
        DateTime dtFecha = DateTime.MinValue;

        DateTime.TryParseExact(e.Row.Cells[0].Text, "dd-MM-yyyy", new CultureInfo("es-CL"), DateTimeStyles.None, out dtFecha);

        e.Row.Cells[0].Attributes.Add("data-order", dtFecha.Ticks.ToString());
      }
    }
    #endregion

    #region Persistencia 

    #endregion

  }
}