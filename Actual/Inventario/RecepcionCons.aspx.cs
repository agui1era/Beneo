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
  public partial class RecepcionCons : FrmBase {

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
      miMaster.MarcarMenu("mniRecepCons", "mniConsulta");
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

      Filtro.Agregar(new FiltroDropDown(ddlEstado, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Recepcion.IdEstado", "Estado", TipoDatos.Entero));
      Filtro.Agregar(new FiltroTextBox(txtFechaDesde, OpcSeleccion.ControlConValor, TipoOperadores.MayorIgual, "Recepcion.Fecha", "FechaDesde", TipoDatos.Fecha));
      Filtro.Agregar(new FiltroTextBox(txtFechaHasta, OpcSeleccion.ControlConValor, TipoOperadores.MenorIgual, "Recepcion.Fecha", "FechaHasta", TipoDatos.Fecha));
      Filtro.Agregar(new FiltroDropDown(ddlUsuarioCrea, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "UsuarioCrea.Id", "UsuarioCrea", TipoDatos.Entero));
      Filtro.Agregar(new FiltroDropDown(ddlProducto, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "RecepcionDet.IdProducto", "Producto", TipoDatos.Entero));
      Filtro.Agregar(new FiltroDropDown(ddlBodega, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Recepcion.IdBodega", "Bodega", TipoDatos.Entero));
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
      LlenarddlEstado(false);
      LlenarddlUsuarioCrea(false);
      LlenarddlProducto(false);
      LlenarddlBodega(false);
    }

    private bool LlenarddlEstado(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheRecepcionEstado");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }
      if (dt != null)

        if (dt == null) {
          dt = new DataTable();
          dt.Columns.Add("Id");
          dt.Columns.Add("Estado");
        }

      ddlEstado.DataSource = new DataView(dt, "", "Estado", DataViewRowState.OriginalRows);
      ddlEstado.DataBind();
      return true;
    }

    
    private bool LlenarddlUsuarioCrea(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheResponsable");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }
      if (dt != null)

        if (dt == null) {
          dt = new DataTable();
          dt.Columns.Add("Id");
          dt.Columns.Add("usu_usuario");
        }

      ddlUsuarioCrea.DataSource = new DataView(dt, "", "usu_usuario", DataViewRowState.OriginalRows);
      ddlUsuarioCrea.DataBind();

      return true;
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

      ddlProducto.DataSource = new DataView(dt, "", "Descripcion", DataViewRowState.OriginalRows);
      ddlProducto.DataBind();
      return true;
    }

    private bool LlenarddlBodega(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheBodega");

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

      ddlBodega.DataSource = new DataView(dt, "", "Nombre", DataViewRowState.OriginalRows);
      ddlBodega.DataBind();

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

      DataTable dtsTabla = objApp.TraerTabla("RecepcionSel_Grids", objParam, 60);

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
      LlamarFormulario("RecepcionAct.aspx", -1);
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
        LlamarFormulario("RecepcionAct.aspx", e.CommandArgument);
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