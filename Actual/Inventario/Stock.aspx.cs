using ITD.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.General;

namespace WEB.Inventario {
  public partial class Stock : FrmBase {

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
      miMaster.MarcarMenu("mniStock", "mniInventario");
      if (!IsPostBack) {
        InicializarFiltros();

        LlenarDdls();
        IniciaParametros();
        dtgStock.PageSize = 20;

        LlenarGrilla();

      } 
    }

    public override void InicializarFiltros() {
      base.InicializarFiltros();

      Filtro.Agregar(new FiltroDropDown(ddlProducto, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Existencia.IdProducto", "IdProducto", TipoDatos.Entero));
      Filtro.Agregar(new FiltroDropDown(ddlBodega, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Bodega.Id", "Nombre", TipoDatos.Entero));
      Filtro.Agregar(new FiltroTextBox(txtFechaDesde, OpcSeleccion.ControlConValor, TipoOperadores.MayorIgual, "Existencia.FechaVcto", "Fecha Vcto Desde", TipoDatos.Fecha));
      Filtro.Agregar(new FiltroTextBox(txtFechaHasta, OpcSeleccion.ControlConValor, TipoOperadores.MenorIgual, "Existencia.FechaVcto", "Fecha Vcto Hasta", TipoDatos.Fecha));


    }

    private void IniciaParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);

      this.SalvaForma = true;

    }


    #endregion

    #region Actualizar


    private void Mover(int intId) {
      object[] objParam = new object[] {
        intId,
        ddlBodegaCambio.SelectedValue,
        Global.convertiraNumero(txtCantidad.Text)
      };

      if (objApp.Ejecutar("ExistenciaMover", objParam)) {
        miMaster.MensajeInformacion(this);
        Filtrar();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }


    #endregion

    #region Interfaz

    private void LlenarDdls() {
      LlenarddlProducto(false);
      LlenarddlBodega(false);
      LlenarddlBodegaMover(false);
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

    private bool LlenarddlBodegaMover(bool bolMostrarMensaje) {
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

      ddlBodegaCambio.DataSource = new DataView(dt, "", "Nombre", DataViewRowState.OriginalRows);
      ddlBodegaCambio.DataBind();

      return true;
    }

    private void LlenarControlesBodega() {
      DataTable dt = objApp.TraerTabla("BodegaSel_Grids", new object[] { });

      if (dt != null) {
        ;

        ddlBodega.DataSource = dt.DefaultView;
        ddlBodega.DataBind();
      }
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

    private void Filtrar() {
      if (Filtro == null)
        InicializarFiltros();
      string strError = Filtro.ValidarFiltros();
      if (string.IsNullOrEmpty(strError)) {
        Filtro.FormarFiltro();
        LlenarGrilla();
      } else {
      }
    }

    private void LlenarGrilla() {
      object[] objParam;

      objParam = new object[]{
        dtgStock.PageIndex,
        dtgStock.PageSize,
        0,
        TomarOrdenGrilla(dtgStock),
        Filtro.Filtro,
        null
      };

      DataTable dtsTabla = objApp.TraerTabla("ExistenciaSel_Grids", objParam, 60);

      if (dtsTabla != null) {

        dtgStock.PageIndex = (int)objParam[0];
        RefrescarGrilla(dtgStock, dtsTabla.DefaultView, (int)objParam[2]);

      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
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

    //protected void btnNuevo_Click(object sender, EventArgs e) {
    //  LlamarFormulario("Producto.aspx", -1);
    //}

    protected void btnGuardarModalCancelar_Click(object sender, EventArgs e) {
      Mover(Convert.ToInt32(hdfIdSel.Value));
    }
    #endregion

    #region Eventos de Grilla

    protected void dtgStock_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgStock.PageIndex = e.NewPageIndex;
      Filtrar();
    }

    protected void dtgStock_Sorting(object sender, GridViewSortEventArgs e) {
      SetearOrdenGrilla(dtgStock, e.SortExpression);
      Filtrar();
    }

    protected void dtgStock_RowCommand(object sender, GridViewCommandEventArgs e) {
      if (e.CommandName == "Modificar") {
        ddlBodegaCambio.SelectedIndex = -1;
        txtCantidad.Text = "";
        hdfIdSel.Value = e.CommandArgument.ToString();
        string script3 = "<script type=text/javascript> $(function () {$('#modal-Futura').modal('show')}); </script>";
        ClientScript.RegisterClientScriptBlock(GetType(), "Error", script3);
      }
    }

    protected void dtgStock_DataBound(object sender, EventArgs e) {
      if(dtgStock.HeaderRow != null)
      dtgStock.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgStock_RowCreated(object sender, GridViewRowEventArgs e) {

      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }


    #endregion

    #region Persistencia
    #endregion

  }
}