using ITD.Web;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.General;

namespace WEB {
  public partial class MermaCons : FrmBase {

    #region Declaraciones 
    
    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }
    int MermaId = 0;
    enum MODAL_MERMA {
      Crear,
      Modificar,
      Eliminar
    }
    #endregion

    #region Inicial        

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniMerma", "mniMerma");
      if (!IsPostBack) {
        InicializarFiltros();

        LlenarDdls();
        IniciaParametros();
        dtgPrincipal.PageSize = 20;

        CargarGrilla();
      } else {
        //dttDdls = (DataTable)ViewState["dttDdls"];
        MermaId = (int)ViewState["Id"];

      }
    }

    public override void InicializarFiltros() {
      base.InicializarFiltros();

      Filtro.Agregar(new FiltroDropDown(ddlProducto, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Merma.IdProducto", "Producto", TipoDatos.Entero));
      Filtro.Agregar(new FiltroDropDown(ddlHerramienta, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Merma.IdHerramienta", "Herramienta", TipoDatos.Entero));
      Filtro.Agregar(new FiltroDropDown(ddlMotivo, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "MermaMotivo.Id", "Motivo", TipoDatos.Entero));
      Filtro.Agregar(new FiltroDropDown(ddlUsuarioCrea, OpcSeleccion.ControlConValor, TipoOperadores.Igual, "Merma.IdUsuarioCrea", "Usuario", TipoDatos.Entero));


    }

    private void IniciaParametros() {
      if (objApp.InfoUsr.IdUsuario == null)
        LlamarFormulario("../Login", null);

      this.SalvaForma = true;

    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("Id", MermaId);
    }

    #endregion

    #region Actualizar        

    #endregion

    #region Interfaz        

    public void Insertar() {
      object[] objParam = new object[] {
              0,
              txtFecha.Text,
              txtObservacion.Text,
              ddlMotivoIns.SelectedValue,
              ddlProductoIns.SelectedValue,
              objApp.InfoUsr.IdUsuario
      };
      if (objApp.Ejecutar("MermaIns", objParam)) {
        //miModalUpd.Visible = false;
        MermaId = (int)objParam[0];
        miMaster.MensajeInformacion(this);

      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    public void Eliminar() {
      object[] objParam = new object[] { MermaId };
      CargarGrilla();
      if (objApp.Ejecutar("MermaDel", objParam)) {
          miMaster.MensajeInformacion(this);
          CargarGrilla();
        } else {
          miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
        }
    }
    
    public void Modificar() {
      object[] objParam = new object[] {
              MermaId,
              txtFecha.Text,
              txtObservacion.Text,
              ddlMotivoIns.SelectedValue,
              ddlProductoIns.SelectedValue,
              objApp.InfoUsr.IdUsuario
      };
      if (objApp.Ejecutar("MermaUpd", objParam)) {
        miModalIns.Visible = false;
        MermaId = (int)objParam[0];
        miMaster.MensajeInformacion(this);
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }
    
    #region Modal 

    private void LLamarModalMerma( MODAL_MERMA objTipo) {
    
      switch (objTipo) {
        case MODAL_MERMA.Crear:
          string script3 = "<script type=text/javascript> $(function () {$('#miModalIns').modal('show')}); </script>";
          ClientScript.RegisterClientScriptBlock(GetType(), "Error", script3);
          break;
        case MODAL_MERMA.Eliminar:
          string script2 = "<script type=text/javascript> $(function () {$('#miModalDel').modal('show')}); </script>";
          ClientScript.RegisterClientScriptBlock(GetType(), "Error", script2);
          break;
        case MODAL_MERMA.Modificar:
          string script1 = "<script type=text/javascript> $(function () {$('#miModalUpd').modal('show')}); </script>";
          ClientScript.RegisterClientScriptBlock(GetType(), "Error", script1);
          break;
        default:
          break;
      }
    }

    #endregion
    
    private void LlenarDdls() {
      LlenarddlProducto(false);
      LlenarddlMermaMotivo(false);
      LlenarddlUsuario(false);
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

      ddlProducto.DataSource = new DataView(dt, "", "Descripcion", DataViewRowState.OriginalRows);
      ddlProducto.DataBind();

      return true;
    }

    private bool LlenarddlMermaMotivo(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheMermaMotivo");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }
      if (dt != null)

        if (dt == null) {
          dt = new DataTable();
          dt.Columns.Add("Id");
          dt.Columns.Add("Motivo");
        }

      ddlMotivo.DataSource = new DataView(dt, "", "Motivo", DataViewRowState.OriginalRows);
      ddlMotivo.DataBind();

      return true;
    }

    private bool LlenarddlUsuario(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheUsuario");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }
      if (dt != null)

        if (dt == null) {
          dt = new DataTable();
          dt.Columns.Add("IdUsuarioCrea");
          dt.Columns.Add("Nombre");
        }

      ddlUsuarioCrea.DataSource = new DataView(dt, "", "Nombre", DataViewRowState.OriginalRows);
      ddlUsuarioCrea.DataBind();

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

    private void Filtrar() {
      //if (Validar()) {
      if (Filtro == null)
        InicializarFiltros();
      string strError = Filtro.ValidarFiltros();
      if (string.IsNullOrEmpty(strError)) {
        Filtro.FormarFiltro();
        CargarGrilla();
      } else {
        //miMaster.MostrarMensaje(ClaseGeneral.STR_ERROR, strError);
      }
      //}
    }

    private void CargarGrilla() {

      DataTable dttTabla = objApp.TraerTabla("MermaSel_Grids", new object[] { Filtro.Filtro });

      if (dttTabla != null) {
        RefrescarGrilla(dtgPrincipal, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
          return;
        }
      }
    }



    private void LlenarControles() {

      DataSet dt = objApp.TraerDataset("MermaSel_Id", new object[] { MermaId });

      if (dt != null && dt.Tables[0].Rows.Count > 0) {
        DataRow dtr = dt.Tables[0].Rows[0];

        MermaId = (int)dtr["Id"];
        txtFecha.Text = dtr["Fecha"].ToString();
        txtObservacion.Text = dtr["Observacion"].ToString();
        ddlMotivoIns.SelectedValue = dtr["IdMotivo"].ToString();
        ddlProductoIns.SelectedValue = dtr["IdProducto"].ToString();
        objApp.InfoUsr.IdUsuario = dtr["IdUsuario"].ToString();
        btnGuardarModal.Enabled = true;
        //btnModificarModal.Enabled = true;
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
    //  LlamarFormulario("Programacion.aspx", -1);
    //}

    #endregion

    #region Eventos de Grillas
      
    //protected void dtgPrincipal_RowCommand(object sender, GridViewCommandEventArgs e) {
    //  if (e.CommandName == "Modificar") {
    //    LlamarFormulario("MermaCons.aspx", e.CommandArgument);
    //  }
    //}

    protected void dtgPrincipal_DataBound(object sender, EventArgs e) {
      if (dtgPrincipal.HeaderRow != null)
        dtgPrincipal.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgPrincipal_RowCreated(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }

    protected void dtgPrincipal_RowDataBound(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.DataRow) {
        DateTime dtFecha = DateTime.MinValue;

        DateTime.TryParseExact(e.Row.Cells[3].Text, "dd-MM-yyyy", new CultureInfo("es-CL"), DateTimeStyles.None, out dtFecha);

        e.Row.Cells[3].Attributes.Add("data-order", dtFecha.Ticks.ToString());


        dtFecha = DateTime.MinValue;
        DateTime.TryParseExact(e.Row.Cells[5].Text, "dd-MM-yyyy HH:mm", new CultureInfo("es-CL"), DateTimeStyles.None, out dtFecha);

        e.Row.Cells[5].Attributes.Add("data-order", dtFecha.Ticks.ToString());

      }

    }
    #endregion

    #region Persistencia 

    #endregion


    //protected void btnNuevo_Click(object sender, EventArgs e) {
    //  ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "openModal();", true);
    //}

    protected void btnModificar_Click(object sender, EventArgs e) {
      LLamarModalMerma(MODAL_MERMA.Modificar);
    }

    protected void btnEliminar_Click(object sender, EventArgs e) {
      Eliminar();

    }

    protected void btnCrear_Click(object sender, EventArgs e) {
      LLamarModalMerma(MODAL_MERMA.Crear);

    }

    protected void btnGuardarModal_Click(object sender, EventArgs e) {
      Insertar();
    }

    protected void btnModificarModal_Click(object sender, EventArgs e) {
      Modificar();
    }

  }
}