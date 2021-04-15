using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.General;
using ITD.Web;
using ITD.Funciones;
using System.IO;
using ITD.Log;
using System.Data;
using System.Text;
using ITD.AccDatos;
using System.Web.Services;

namespace WEB {
  public partial class Producto : FrmBase {

    #region Declaracion
    protected new ClaseGeneral objApp {
      get { return (ClaseGeneral)base.objApp; }
      set { base.objApp = value; }
    }

    private WEB.Maestro miMaster {
      get { return (WEB.Maestro)this.Master; }
    }

    int Id_Producto = 0;


    #endregion

    #region Inicial
    protected void Page_Load(object sender, EventArgs e) {
      miMaster.MarcarMenu("mniProducto", "mniConf");

      if (!IsPostBack) {
        IniciarParametros();
        LlenarDdls();
        LimpiarControles();
        CargarGrilla();
      } else {
        Id_Producto = (int)ViewState["Id_Producto"];
      }
    }

    protected void Page_PreRender(object sender, EventArgs e) {
      ViewState.Add("Id_Producto", Id_Producto);
    }

    #endregion

    #region Actualizar

    private void Insertar() {
      object[] objParam = new object[] {
        0,
        txtCodigo.Text,
        txtNombre.Text,
        ddlUM.SelectedValue,
        ddlCategoria.SelectedValue,
        objApp.InfoUsr.IdUsuario,
        convertiraNumero(txtLimite.Text),
        txtIngredienteActivo.Visible ? txtIngredienteActivo.Text : ddlIngredienteActivo.Text
      };

      if (objApp.Ejecutar("ProductoIns", objParam)) {
        Id_Producto = (int)objParam[0];
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Eliminar() {
      object[] objParam = new object[] {
        Id_Producto
      };

      if (objApp.Ejecutar("ProductoDel", objParam)) {
        miMaster.MensajeInformacion(this);
        LimpiarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }

    private void Modificar() {
      object[] objParam = new object[] {
        Id_Producto, 
        txtCodigo.Text,
        txtNombre.Text,
        ddlUM.SelectedValue,
        ddlCategoria.SelectedValue,
        objApp.InfoUsr.IdUsuario,
        convertiraNumero(txtLimite.Text),
        txtIngredienteActivo.Text
      };

      if (objApp.Ejecutar("ProductoUpd", objParam)) {
        miMaster.MensajeInformacion(this);
        LlenarControles();
        CargarGrilla();
      } else {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));
      }
    }
    #endregion
    
    #region Interfaz   

    private bool Validar() {
      StringBuilder stbError = new StringBuilder();
      
      if (string.IsNullOrWhiteSpace(txtNombre.Text))
        stbError.AppendLine("Producto es requerido.");

      if (string.IsNullOrWhiteSpace(ddlUM.SelectedValue))
        stbError.AppendLine("UM es requerido.");
      
      if (stbError.Length > 0) {
        stbError.Insert(0, "Existen campos con errores: \n");
        stbError.Replace("\n", "<br>");
        miMaster.MensajeError(this, Global.ERROR, stbError.ToString());
        return false;
      }
      return true;
    }

    private void LimpiarControles() {
      Id_Producto = 0;
      txtCodigo.Text = null;
      txtNombre.Text = null;
      ddlUM.SelectedIndex = -1;
      txtLimite.Text = "";
      txtIngredienteActivo.Text = "";
      ddlCategoria.SelectedIndex = -1;
      btnNuevo.Enabled = false;
      btnEliminar.Enabled = false;
      btnGuardar.Enabled = true;

      DataTable dt = objApp.TraerTabla("ProductoExisteSel_Ddl");

      ddlProdExiste.DataSource = dt.DefaultView;
      ddlProdExiste.DataBind();

      LlenarddlIngredienteActivo(false);

      ddlProdExiste.Visible = true;
      ddlIngredienteActivo.Visible = true;
      txtIngredienteActivo.Visible = false;
      btnIngredienteActivo.Visible = true;
      txtNombre.Visible = false;
      btnNuevoProd.Visible = true;

    }

    private void CargarGrilla() {

      DataTable dttTabla = objApp.TraerTabla("ProductoSel_Grids");

      if (dttTabla != null) {
        RefrescarGrilla(dtgProductos, dttTabla.DefaultView, false);
      } else {
        if (objApp.UltimoError != null && objApp.UltimoError.Numero == -2) {
          miMaster.MensajeError(this, Global.ERROR, "Error consultando los datos. Expiró el tiempo de consulta. Posible causa: Demasiados registros.");
          return;
        }
      }
    }

    private void LlenarDdls() {
      LlenarddlUM(false);
      LlenarddlCategoria(false);
      LlenarddlIngredienteActivo(false);
      
    }
    
    private bool LlenarddlUM(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheUnidadMedida");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }

      if (dt == null) {
        dt = new DataTable();
        dt.Columns.Add("Id");
        dt.Columns.Add("Sigla");
      }

      ddlUM.DataSource = new DataView(dt, "Id > 0", "Sigla", DataViewRowState.OriginalRows);
      ddlUM.DataBind();

      return true;
    }

    private bool LlenarddlCategoria(bool bolMostrarMensaje) {
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

      ddlCategoria.DataSource = new DataView(dt, "", "Id", DataViewRowState.OriginalRows);
      ddlCategoria.DataBind();

      return true;
    }

    private bool LlenarddlIngredienteActivo(bool bolMostrarMensaje) {
      DataTable dt = objApp.TraerTabla("CacheIngredienteActivo");

      if (dt == null && bolMostrarMensaje) {
        miMaster.MensajeError(this, Global.ERROR, ProcesarError(objApp.UltimoError));

        return false;
      }

      if (dt == null) {
        dt = new DataTable();
        dt.Columns.Add("IngredienteActivo");
      }

      ddlIngredienteActivo.DataSource = new DataView(dt, "", "IngredienteActivo", DataViewRowState.OriginalRows);
      ddlIngredienteActivo.DataBind();

      return true;
    }

    private void LlenarControles() {

      DataSet dt = objApp.TraerDataset("ProductoSel_Id", new object[] { Id_Producto });

      if (dt != null && dt.Tables[0].Rows.Count > 0) {
        DataRow dtr = dt.Tables[0].Rows[0];

        Id_Producto = (int)dtr["Id"];
        txtCodigo.Text = dtr["Codigo"].ToString();
        txtNombre.Text = dtr["Descripcion"].ToString();
        ddlUM.SelectedValue = dtr["IdUnidadMedida"].ToString();
        ddlCategoria.SelectedValue = dtr["IdCategoria"].ToString();
        txtIngredienteActivo.Text = dtr["IngredienteActivo"].ToString();

        if (dtr.IsNull("Limite"))
          txtLimite.Text = "";
        else
          txtLimite.Text = ((decimal)dtr["Limite"]).ToString("#,##0.##");

        txtNombre.Visible = true;
        ddlProdExiste.Visible = false;


        ddlIngredienteActivo.Visible = false;
        txtIngredienteActivo.Visible = true;
        btnIngredienteActivo.Visible = false;

        btnNuevoProd.Visible = false;
        btnNuevo.Enabled = true;
        btnEliminar.Enabled = true;
        btnGuardar.Enabled = true;
      }
    }
    
    #endregion

    #region Acciones

    private decimal? convertiraNumero(string text) {
      if (string.IsNullOrWhiteSpace(text))
        return null;


      text = text.Replace(".", ",");
      decimal numero = 0;
      if (string.IsNullOrWhiteSpace(text)) {
        return numero;
      } else {
        if (decimal.TryParse(text, out numero)) {
          return numero;
        } else {
          return numero;
        }
      }

    }

    #endregion

    #region Eventos de Barra

    #endregion

    #region Eventos de Controles

    protected void btnGuardar_Click(object sender, EventArgs e) {
      if (!Validar())
        return;

      if (Id_Producto == 0)
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

    protected void btnNuevoProd_Click(object sender, EventArgs e) {
      ddlProdExiste.Visible = false;
      txtNombre.Visible = true;
    }

    protected void btnIngredienteActivo_Click(object sender, EventArgs e) {
      ddlIngredienteActivo.Visible = false;
      txtIngredienteActivo.Visible = true;
    }

    #endregion

    #region Eventos de Grillas

    protected void dtgProductos_PageIndexChanging(object sender, GridViewPageEventArgs e) {
      dtgProductos.PageIndex = e.NewPageIndex;
      dtgProductos.DataBind();
      CargarGrilla();
    }

    protected void dtgProductos_RowCommand(object sender, GridViewCommandEventArgs e) {
      Id_Producto = Convert.ToInt32(e.CommandArgument);
      if (e.CommandName == "Modificar") {
        LlenarControles();
      }
    }

    protected void dtgProductos_DataBound(object sender, EventArgs e) {
      if (dtgProductos.HeaderRow != null)
        dtgProductos.HeaderRow.TableSection = TableRowSection.TableHeader;
    }

    protected void dtgProductos_RowCreated(object sender, GridViewRowEventArgs e) {

      if (e.Row.RowType == DataControlRowType.Header) {
        e.Row.TableSection = TableRowSection.TableHeader;
      }
    }

    #endregion

    #region Persistencia 

    #endregion

  }
}