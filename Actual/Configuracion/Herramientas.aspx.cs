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

namespace WEB {
  public partial class Herramientas : FrmBase {

    #region Declaraciones

    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int IdHerramienta;

    #endregion

    #region Inicial 

    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniHerramientas", "mniConf");
      if (!IsPostBack) {
        LimpiarControles();
        IniciarParametros();
        LlenarDdls();
      } else {
        IdHerramienta = (int)ViewState["Id"];
      }
    }
    
    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("Id", IdHerramienta);
    }
    
    private void IniciarParametros() {
      CargarGrilla();
    }

    #endregion

    #region Actualizar

    private void Insertar() {
      object[] objParam = new object[] {
        0,
        txtCodigo.Text,
        txtHerramienta.Text,
        ddlCategoria.SelectedValue

      };

      if (objApp.Ejecutar("HerramientasIns", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Eliminar() {
      object[] objParam = new object[] {
        IdHerramienta
      };

      if (objApp.Ejecutar("HerramientasDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      object[] objParam = new object[] {
        IdHerramienta,
        txtCodigo.Text,
        txtHerramienta.Text,
        ddlCategoria.SelectedValue
      };

      if (objApp.Ejecutar("HerramientasUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }
    private void LlenarControles() {

      DataSet dt = objApp.TraerDataset("HerramientaSel_Id", new object[] { IdHerramienta });

      if (dt != null && dt.Tables[0].Rows.Count > 0) {
        DataRow dtr = dt.Tables[0].Rows[0];

        IdHerramienta = (int)dtr["Id"];
        txtCodigo.Text = dtr["Codigo"].ToString();
        txtHerramienta.Text = dtr["Nombre"].ToString();
        ddlCategoria.SelectedValue = dtr["IdCategoria"].ToString();

        ddlCategoria.SelectedIndex = -1;
        btnNuevo.Enabled = true;
        btnEliminar.Enabled = true;
        btnGuardar.Enabled = true;
      }
    }

    #endregion

    #region Interfaz

    private bool LlenarddlCategoria(bool bolMostrarMensaje) {
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

      ddlCategoria.DataSource = new DataView(dt, "", "Id", DataViewRowState.OriginalRows);
      ddlCategoria.DataBind();

      return true;

    }

    private bool Validar() {
      StringBuilder stbError = new StringBuilder();

      if (string.IsNullOrWhiteSpace(txtCodigo.Text))
        stbError.AppendLine("Código es requerido.");
      
      if (stbError.Length > 0) {
        stbError.Insert(0, "Existen campos con errores: \n");
        stbError.Replace("\n", "<br>");
        miMaster.MensajeError(this, Global.ERROR, stbError.ToString());
        return false;
      }
      return true;
    }

    private void LimpiarControles() {
      IdHerramienta = 0;
      txtCodigo.Text = null;
      txtHerramienta.Text = null;
      btnNuevo.Enabled = false;
      btnEliminar.Enabled = false;
      btnGuardar.Enabled = true;
      txtHerramienta.Visible = false;
      ddlHerramientaExiste.Visible = true;
      btnNuevaHerr.Visible = true;
      ddlCategoria.SelectedIndex = -1;
    }

    private void CargarGrilla() {

      DataTable dttTabla = objApp.TraerTabla("HerramientasSel_Grids");

      if (dttTabla != null) {
        RefrescarGrilla(dtgHerramientas, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
          return;
        }
      }
    }

    private void LlenarDdls() {

      LlenarddlHerramienta(false);
      LlenarddlCategoria(false);
      
    }

    private bool LlenarddlHerramienta(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheHerramienta");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }

      if (dt == null) {
        dt = new DataTable();
        dt.Columns.Add("IdHerramienta");
        dt.Columns.Add("Nombre");
      }

      ddlHerramientaExiste.DataSource = new DataView(dt, "", "Nombre", DataViewRowState.OriginalRows);
      ddlHerramientaExiste.DataBind();

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

      if (IdHerramienta == 0)
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

    protected void btnNuevaHerr_Click(object sender, EventArgs e) {
      ddlHerramientaExiste.Visible = false;
      btnNuevaHerr.Visible = false;
      txtHerramienta.Visible = true;
    }

    #endregion

    #region Eventos de Grilla


    protected void dtgHerramientas_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgHerramientas.PageIndex = e.NewPageIndex;
      dtgHerramientas.DataBind();
      CargarGrilla();
    }

    protected void dtgHerramientas_RowCommand(object sender, GridViewCommandEventArgs e) {
      IdHerramienta = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Modificar") {

        DataSet dt = objApp.TraerDataset("HerramientasSel_Id", new object[] { IdHerramienta.ToString() });

        if (dt != null && dt.Tables[0].Rows.Count > 0) {
          DataRow dtr = dt.Tables[0].Rows[0];

          IdHerramienta = (int)dtr["Id"];
          txtCodigo.Text = dtr["Codigo"].ToString();
          txtHerramienta.Text = dtr["Nombre"].ToString();
          ddlCategoria.SelectedValue = dtr["IdCategoria"].ToString();
          btnNuevo.Enabled = true;
          btnEliminar.Enabled = true;
          btnGuardar.Enabled = true;
          btnNuevaHerr.Visible = false;
          txtHerramienta.Visible = true;
          ddlHerramientaExiste.Visible = false;
        }
      }
    }



    #endregion

    #region Persistencia
    #endregion

    protected void dtgHerramientas_DataBound(object sender, EventArgs e) {
      if (dtgHerramientas.HeaderRow != null)
        dtgHerramientas.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgHerramientas_RowCreated(object sender, GridViewRowEventArgs e) {
      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }
  }
}