using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ITD.Web;
using System.Data;
using WEB.General;

namespace WEB {
  public partial class PrograActividadesCons : FrmBase {

    #region Declaraciones 

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniPrograAct", "mniProgra");
      if (!IsPostBack) {
        InicializarFiltros();

        LlenarDdls();
        IniciaParametros();
        dtgPrincipal.PageSize = 20;

        LlenarGrilla();

      } else {
        //dttDdls = (DataTable)ViewState["dttDdls"];
      }
    }

    public override void InicializarFiltros() {
      base.InicializarFiltros();

      Filtro.Agregar(new FiltroDropDown(ddlEnsayo, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Programacion.IdEnsayo", "Ensayo", TipoDatos.Entero));
      Filtro.Agregar(new FiltroDropDown(ddlLugar, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Programacion.IdLugar", "Lugar", TipoDatos.Entero));
      Filtro.Agregar(new FiltroDropDown(ddlEspecie, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Ensayo.IdEspecie", "Especie", TipoDatos.Entero));
      Filtro.Agregar(new FiltroDropDown(ddlResponsable, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Programacion.IdResponsable", "Responsable", TipoDatos.Entero));
      Filtro.Agregar(new FiltroDropDown(ddlTemporada, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Programacion.IdTemporada", "Temporada", TipoDatos.Entero));
      Filtro.Agregar(new FiltroTextBox(txtActividad, OpcSeleccion.ControlConValor, TipoOperadores.Contiene, "ProgramacionActividad.Actividad", "Actividad", TipoDatos.Texto ));


    }

    private void IniciaParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);

      this.SalvaForma = true;

    }

    #endregion

    #region Actualizar        

    #endregion

    #region Interfaz        

    private void LlenarDdls() {
      LlenarddlEnsayo(false);
      LlenarddlLugar(false);
      LlenarddlResponsable(false);
      LlenarddlEspecie(false);
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

      ddlTemporada.DataSource = new DataView(dt, "", "Nombre", DataViewRowState.OriginalRows);
      ddlTemporada.DataBind();
      return true;
    }

    private bool LlenarddlEnsayo(bool bolMostrarMensaje) {
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

      ddlEnsayo.DataSource = new DataView(dt, "", "Codigo", DataViewRowState.OriginalRows);
      ddlEnsayo.DataBind();

      return true;
    }

    private bool LlenarddlLugar(bool bolMostrarMensaje) {
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

      ddlLugar.DataSource = new DataView(dt, "", "Nombre", DataViewRowState.OriginalRows);
      ddlLugar.DataBind();

      return true;
    }

    private bool LlenarddlResponsable(bool bolMostrarMensaje) {
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

      ddlResponsable.DataSource = new DataView(dt, "", "nombre_empleado", DataViewRowState.OriginalRows);
      ddlResponsable.DataBind();

      return true;
    }

    private bool LlenarddlEspecie(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheEspecie");

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

      ddlEspecie.DataSource = new DataView(dt, "", "Nombre", DataViewRowState.OriginalRows);
      ddlEspecie.DataBind();

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

      DataTable dtsTabla = objApp.TraerTabla("ProgramacionActividadConsSel_Grids", objParam, 60);

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

    #endregion

    #region Acciones

    #endregion

    #region Eventos de Barra

    #endregion

    #region Eventos de Controles

    protected void btnFiltrar_Click(object sender, EventArgs e) {
      Filtrar();
    }

    protected void btnNuevo_Click(object sender, EventArgs e) {
      LlamarFormulario("Programacion.aspx", -1);
    }

    #endregion

    #region Eventos de Grillas

    protected void dtgPrincipal_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgPrincipal.PageIndex = e.NewPageIndex;
      Filtrar();
    }

    protected void dtgPrincipal_Sorting(object sender, GridViewSortEventArgs e) {
      SetearOrdenGrilla(dtgPrincipal, e.SortExpression);
      Filtrar();
    }

    protected void dtgPrincipal_RowCommand(object sender, GridViewCommandEventArgs e) {
      if (e.CommandName == "Modificar") {
        string[] strSplit = e.CommandArgument.ToString().Split(',');


        LlamarFormulario("IngresoActividad.aspx", new object[] { strSplit[1], strSplit[0] });
      }
    }

    protected void dtgPrincipal_DataBound(object sender, EventArgs e) {
      dtgPrincipal.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgPrincipal_RowCreated(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }

    #endregion

    #region Persistencia 

    #endregion

  }
}